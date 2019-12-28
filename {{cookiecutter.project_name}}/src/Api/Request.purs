module Api.Request where

import Prelude

import Affjax                       (Request, request)
import Affjax.RequestBody           as RB
import Affjax.ResponseFormat        as RF
import Affjax.RequestHeader         (RequestHeader(..))
import Control.Monad.Reader.Class   (class MonadAsk, asks)
import Data.Argonaut.Core           (Json)
import Data.Either                  (Either(..), hush)
import Data.Maybe                   (Maybe(..))
import Data.HTTP.Method             (Method(..))
import Data.Tuple                   (Tuple(..))
import Effect.Aff.Class             (class MonadAff, liftAff)

import Data.URL                     (BaseURL(..))

type Endpoint = String
newtype Token = Token String

derive instance eqToken  :: Eq Token
derive instance ordToken :: Ord Token

instance showToken :: Show Token where
  show (Token _) = "Token {- token -}"

data RequestMethod 
  = Get
  | Post (Maybe Json)
  | Put (Maybe Json)
  | Delete

type RequestOptions =
  { endpoint :: Endpoint
  , method   :: RequestMethod
  }

defaultRequest :: BaseURL        -> 
                  Maybe Token    -> 
                  RequestOptions -> 
                  Request Json
defaultRequest (BaseURL baseUrl) auth { endpoint, method } =
  { method: Left method 
  , url: baseUrl <> endpoint
  , headers: case auth of
      Nothing -> []
      Just (Token t) -> [ RequestHeader "Authorization" $ "Token " <> t ]
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

mkRequest :: forall m r
           . MonadAff m
          => MonadAsk { apiURL :: BaseURL | r } m
          => RequestOptions
          -> m (Maybe Json)
mkRequest opts = do
  apiUrl <- asks _.apiURL
  response <- liftAff 
           $ request 
           $ defaultRequest apiUrl Nothing opts
  pure $ hush response.body
