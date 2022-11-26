module Api.Utils where

import Prelude
import Data.Auth (UserAuth(..), base64encode, writeToken)
import Data.Maybe (Maybe(..))
import Data.User (User)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen.Store.Monad (class MonadStore, updateStore)
import Resource.User (class ManageUser, login)
import Store as Store

authenticate
  :: forall m
   . MonadAff m
  => MonadStore Store.Action Store.Store m
  => ManageUser m
  => UserAuth
  -> m (Maybe User)
authenticate (UserAuth auth) = do
  user <- login $ UserAuth auth
  case user of
    Just u -> do
      let
        token = base64encode
          auth.username
          auth.password
      liftEffect $ writeToken token
      updateStore $ Store.LoginUser u
      pure user
    Nothing -> pure Nothing
