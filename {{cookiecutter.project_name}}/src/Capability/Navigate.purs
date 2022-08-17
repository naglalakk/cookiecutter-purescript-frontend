module Capability.Navigate where

import Prelude

import Control.Monad.Trans.Class (lift)
import Halogen (HalogenM)
import Data.Route (Route)

class Monad m <= Navigate m where
  navigate :: Route -> m Unit

instance navigateHalogenM :: Navigate m => Navigate (HalogenM state action slots output m) where
  navigate = lift <<< navigate

