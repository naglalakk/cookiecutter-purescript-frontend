module Api.Request where

import Prelude

import Affjax                   (Request)
import Affjax.RequestBody as    RB
import Affjax.ResponseFormat as RF
import Affjax.RequestHeader     (RequestHeader(..))
import Data.Argonaut.Core       (Json)
import Data.Either              (Either(..))
import Data.Maybe               (Maybe(..))
import Data.HTTP.Method         (Method(..))
import Data.Tuple               (Tuple(..))

type Endpoint = String
newtype Token = Token String

derive instance eqToken  :: Eq Token
derive instance ordToken :: Ord Token

instance showToken :: Show Token where
  show (Token _) = "Token {- token -}"

newtype BaseURL = BaseURL String

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
