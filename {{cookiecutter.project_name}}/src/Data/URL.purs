module Data.URL where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Newtype (class Newtype)

newtype BaseURL = BaseURL String

derive instance genericBaseURL :: Generic BaseURL _
derive instance newtypeBaseURL :: Newtype BaseURL _
derive instance eqBaseURL :: Eq BaseURL
derive instance ordBaseURL :: Ord BaseURL

instance showBaseURL :: Show BaseURL where
  show = genericShow
