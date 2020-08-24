module Capability.LogMessages where

import Prelude
import Control.Monad.Trans.Class    (lift)
import Halogen                      (HalogenM)

class Monad m <= LogMessages m where
  logMessage :: String -> m Unit

instance logMessagesHalogenM :: LogMessages m => LogMessages (HalogenM state action slots output m) where
  logMessage = lift <<< logMessage
