module Resource.User where

import Prelude
import Data.Maybe           (Maybe)
import Halogen              (HalogenM, lift)

import Data.Auth            (UserAuth)
import Data.User            (User)

class Monad m <= ManageUser m where
  loginUser :: UserAuth -> m (Maybe User)

instance manageUserHalogenM :: ManageUser m => ManageUser (HalogenM st act slots msg m) where
  loginUser = lift <<< loginUser
