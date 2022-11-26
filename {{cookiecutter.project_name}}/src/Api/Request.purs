module Api.Request where

import Prelude

import Affjax (Error)
import Affjax.Web (Request, Response, request)
import Affjax.RequestBody as RB
import Affjax.RequestHeader (RequestHeader(..))
import Affjax.ResponseFormat as RF
import Api.Endpoint (Endpoint, endpointCodec)
import Data.Argonaut.Core (Json)
import Data.Auth (APIAuth(..))
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.URL (BaseURL(..))
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen.Store.Monad (class MonadStore, getStore, updateStore)
import Routing.Duplex (print)
import Store (Store, Action)
import Web.XHR.FormData (FormData)

data RequestMethod
  = Get
  | Post (Maybe Json)
  | PostFormData (Maybe FormData)
  | Put (Maybe Json)
  | Delete

type RequestOptions =
  { endpoint :: Endpoint
  , method :: RequestMethod
  , auth :: Maybe APIAuth
  }

defaultRequest
  :: BaseURL
  -> RequestOptions
  -> Request Json
defaultRequest (BaseURL baseURL) { endpoint, method, auth } =
  { method: Left method
  , url: baseURL <> print endpointCodec endpoint
  , headers: case auth of
      Just (Basic token) -> do
        [ RequestHeader "Authorization" $ "Basic " <> token ]
      Just (Bearer token) ->
        [ RequestHeader "Authorization" $ "Bearer " <> token ]
      Nothing -> []
  , content: case body of
      Just (PostFormData a) -> RB.formData <$> a
      Just (Post a) -> RB.json <$> a
      Just (Put a) -> RB.json <$> a
      _ -> Nothing
  , username: Nothing
  , password: Nothing
  , withCredentials: false
  , responseFormat: RF.json
  , timeout: Nothing
  }
  where
  Tuple method body = case method of
    Get -> Tuple GET Nothing
    Post b -> Tuple POST $ Just $ Post b
    PostFormData b -> Tuple POST $ Just $ PostFormData b
    Put b -> Tuple PUT $ Just $ Put b
    Delete -> Tuple DELETE Nothing

mkRequest
  :: forall m r
   . MonadAff m
  => MonadStore Action Store m
  => RequestOptions
  -> m (Either Error (Response Json))
mkRequest opts = do
  { baseUrl } <- getStore
  liftAff $ request $ defaultRequest baseUrl opts
