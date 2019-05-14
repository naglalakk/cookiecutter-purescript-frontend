module Component.Utils where

import Prelude
import Data.Const   (Const)
import Halogen      as H

-- Helper type for components with  
-- no queries or messages
-- see: https://github.com/thomashoneyman/purescript-halogen-realworld/pull/26
type OpaqueSlot = H.Slot (Const Void) Void
