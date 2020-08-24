module Api.Request where

import Prelude

import Affjax                       (Request, request)
import Affjax.RequestBody           as RB
import Affjax.ResponseFormat        as RF
import Affjax.RequestHeader         (RequestHeader(..))
import Control.Monad.Reader.Class   (class MonadAsk, ask)
import Data.Argonaut.Core           (Json)
import Data.Either                  (Either(..), hush)
import Data.Maybe                   (Maybe(..))
import Data.HTTP.Method             (Method(..))
import Data.Tuple                   (Tuple(..))
import Effect.Aff.Class             (class MonadAff, liftAff)
import Routing.Duplex               (print)
import Web.XHR.FormData             (FormData)
  
import Api.Endpoint                 (Endpoint
                                    ,endpointCodec)
import Data.Auth                    (APIAuth(..))
import Data.URL                     (BaseURL(..))

data RequestMethod
  = Get
  | Post (Maybe Json)
  | Put (Maybe Json)
  | Delete

data FormDataRequestMethod
  = PostFormData (Maybe FormData)

type RequestOptions =
  { endpoint :: Endpoint
  , method   :: RequestMethod {% if cookiecutter.user %}
  , auth     :: Maybe APIAuth {% endif %}
  }

type FormDataOptions =
  { endpoint :: Endpoint
  , method   :: FormDataRequestMethod {% if cookiecutter.user %}
  , auth     :: Maybe APIAuth {% endif %}
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
      Nothing        -> []
  , content: RB.json <$> body
  , username: Nothing
  , password: Nothing
  , withCredentials: false
  , responseFormat: RF.json
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
      Just      _          -> []
      Nothing              -> []
  , content: RB.formData <$> body
  , username: Nothing
  , password: Nothing
  , withCredentials: false
  , responseFormat: RF.json
  }
  where
  Tuple method body = case method of
    PostFormData b -> Tuple POST b

mkRequest :: forall m r
           . MonadAff m
          => MonadAsk { apiURL :: BaseURL | r } m
          => RequestOptions
          -> m (Maybe Json)
mkRequest opts = do
  { apiURL } <- ask
  response <- liftAff $ request $ defaultRequest apiURL opts
  pure $ hush response.body

mkFormDataRequest :: forall m r
                   . MonadAff m
                  => MonadAsk { apiURL :: BaseURL | r } m
                  => FormDataOptions
                  -> m (Maybe Json)
mkFormDataRequest opts = do
  { apiURL } <- ask
  response <- liftAff $ request $ formDataRequest apiURL opts
  pure $ hush response.body
