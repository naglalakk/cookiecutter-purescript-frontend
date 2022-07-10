module Data.Email where

import Prelude
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Newtype (class Newtype)

newtype Email = Email String

derive instance newtypeEmail :: Newtype Email _
derive instance genericEmail :: Generic Email _
derive instance eqEmail :: Eq Email
derive instance ordEmail :: Ord Email

derive newtype instance encodeJsonEmail :: EncodeJson Email
derive newtype instance decodeJsonEmail :: DecodeJson Email

instance showEmail :: Show Email where
  show = genericShow
