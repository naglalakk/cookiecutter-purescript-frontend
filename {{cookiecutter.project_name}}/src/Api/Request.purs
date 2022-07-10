module Api.Request where

import Prelude

import Affjax (Error, Request, Response, request)
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
import Store(Store, Action)
import Web.XHR.FormData (FormData)

data RequestMethod
  = Get
  | Post (Maybe Json)
  | Put (Maybe Json)
  | Delete

data FormDataRequestMethod
  = PostFormData (Maybe FormData)

type RequestOptions =
  { endpoint :: Endpoint
  , method   :: RequestMethod 
  , auth     :: Maybe APIAuth 
  }

type FormDataOptions =
  { endpoint :: Endpoint
  , method   :: FormDataRequestMethod 
  , auth     :: Maybe APIAuth 
  }

defaultRequest :: BaseURL        ->
                  RequestOptions ->
                  Request Json
defaultRequest (BaseURL baseURL) { endpoint, method, auth} =
  { method: Left method
  , url: baseURL <> print endpointCodec endpoint
  , headers: case auth of
      Just (Basic token) -> do
        [ RequestHeader "Authorization" $ "Basic " <> token ]
      Just (Token token) -> 
        [ RequestHeader "Authorization" $ "Bearer " <> token ]
      Nothing -> []
  , content: RB.json <$> body
  , username: Nothing
  , password: Nothing
  , withCredentials: false
  , responseFormat: RF.json
  , timeout: Nothing
  }
  where
  Tuple method body = case method of
    Get    -> Tuple GET Nothing
    Post b -> Tuple POST b
    Put  b -> Tuple PUT b
    Delete -> Tuple DELETE Nothing

formDataRequest :: BaseURL         ->
                   FormDataOptions ->
                   Request Json
formDataRequest (BaseURL baseURL) { endpoint, method, auth} =
  { method: Left method
  , url: baseURL <> print endpointCodec endpoint
  , headers: case auth of
      Just (Basic token) -> 
        [ RequestHeader "Authorization" $ "Basic " <> token ]
      Just (Token token) -> 
        [ RequestHeader "Authorization" $ "Bearer " <> token ]
      Nothing              -> []
  , content: RB.formData <$> body
  , username: Nothing
  , password: Nothing
  , withCredentials: false
  , responseFormat: RF.json
  , timeout: Nothing
  }
  where
  Tuple method body = case method of
    PostFormData b -> Tuple POST b

mkRequest :: forall m r
           . MonadAff m
          => MonadStore Action Store m
          => RequestOptions
          -> m (Either Error (Response Json))
mkRequest opts = do
  { baseUrl } <- getStore
  liftAff $ request $ defaultRequest baseUrl opts

mkFormDataRequest :: forall m r
                   . MonadAff m
                  => MonadStore Action Store m
                  => FormDataOptions
                  -> m (Either Error (Response Json))
mkFormDataRequest opts = do
  { baseUrl } <- getStore
  liftAff $ request $ formDataRequest baseUrl opts
