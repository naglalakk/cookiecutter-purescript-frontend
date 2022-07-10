module Resource.User where

import Prelude
import Data.Auth (UserAuth)
import Data.Maybe (Maybe)
import Data.User (User)
import Halogen (HalogenM, lift)

class Monad m <= ManageUser m where
  login :: UserAuth -> m (Maybe User)
  logout :: m Unit

instance manageUserHalogenM :: ManageUser m => ManageUser (HalogenM st act slots msg m) where
  login = lift <<< login
  logout = lift logout
