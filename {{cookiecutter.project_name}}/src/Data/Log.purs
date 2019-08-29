module Data.Log where

import Prelude
import Data.Generic.Rep (class Generic)

newtype Log = Log
  { message :: String
  }

derive instance genericLog :: Generic Log _
derive instance eqLog :: Eq Log

message :: Log -> String
message (Log { message: m }) = m
