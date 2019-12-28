module Data.URL where 

import Prelude
import Data.Generic.Rep         (class Generic)
import Data.Generic.Rep.Show    (genericShow)
import Data.Newtype             (class Newtype)

newtype BaseURL = BaseURL String

derive instance genericBaseURL :: Generic BaseURL _
derive instance newtypeEmail :: Newtype BaseURL _ 
derive instance eqBaseURL  :: Eq BaseURL
derive instance ordBaseURL :: Ord BaseURL

instance showBaseURL :: Show BaseURL where
  show = genericShow
