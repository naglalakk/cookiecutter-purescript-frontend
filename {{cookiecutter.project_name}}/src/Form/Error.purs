-- Module for commonly used errors

module Form.Error where

import Prelude
import Data.Generic.Rep             (class Generic)
import Data.Generic.Rep.Show        (genericShow)

data FormError 
  = Required          -- Field input is required
  | Invalid           -- Field input is invalid
  | InvalidInt String
  | InvalidNumber String
  | InvalidDateTime String

derive instance genericFormError :: Generic FormError _

instance showFormError :: Show FormError where
  show = genericShow
