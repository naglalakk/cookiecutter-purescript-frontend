module Capability.LogMessages where

import Prelude
import Data.Log                     (Log(..))
import Control.Monad.Trans.Class    (lift)
import Halogen                      (HalogenM)

class Monad m <= LogMessages m where
  logMessage :: Log -> m Unit

instance logMessagesHalogenM :: LogMessages m => LogMessages (HalogenM s f g p o m) where
  logMessage = lift <<< logMessage
