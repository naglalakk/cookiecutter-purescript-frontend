module Api.Utils where

import Prelude
import Data.Maybe           (Maybe(..))
import Data.Newtype         (unwrap)
import Effect.Ref           as Ref
import Effect.Aff.Class     (class MonadAff, liftAff)
import Effect.Aff.Bus       as Bus
import Effect.Class         (liftEffect)

import Data.Auth            (UserAuth(..), base64encode, writeToken)
import Data.Environment     (UserEnv)
import Data.User            (User)
import Resource.User        (class ManageUser
                            ,loginUser)

authenticate :: forall m
              . MonadAff m
             => ManageUser m
             => UserEnv
             -> UserAuth
             -> m (Maybe User)
authenticate { currentUser, userBus } (UserAuth auth) = do
  lUser <- loginUser $ UserAuth auth
  case lUser of
    Just user -> do
      let 
        token = base64encode 
                (unwrap auth.username) 
                (unwrap auth.password)
      liftEffect $ writeToken token
      liftEffect $ Ref.write (Just user) currentUser
      liftAff    $ Bus.write (Just user) userBus
      pure lUser
    Nothing -> pure Nothing
