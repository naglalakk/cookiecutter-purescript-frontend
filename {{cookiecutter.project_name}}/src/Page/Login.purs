module Page.Login where

import Prelude
import Control.Monad.Reader         (class MonadAsk, asks)
import Data.Const                   (Const)
import Data.Maybe                   (Maybe(..))
import Data.Symbol                  (SProxy(..))
import Effect.Aff.Class             (class MonadAff)
import Halogen                      as H
import Halogen.HTML                 as HH
import Formless                     as F

import Api.Utils                    (authenticate)
import Capability.Navigate          (class Navigate)
import Component.HTML.Utils         (css)
import Data.Auth                    (UserAuth)
import Data.Environment             (UserEnv)
import Form.Login                   as LoginForm
import Resource.User                (class ManageUser)

type State =
  { redirect :: Boolean }

type Input =
  { redirect :: Boolean }

data Action 
  = HandleLoginForm UserAuth

type ChildSlots = (
  loginForm :: H.Slot (F.Query LoginForm.LoginForm LoginForm.Query LoginForm.ChildSlots) UserAuth Unit
)
type Query = Const Void

component :: forall m r
           . Monad m
          => MonadAff m
          => MonadAsk { userEnv :: UserEnv | r } m
          => ManageUser m
          => Navigate m
          => H.Component HH.HTML Query Input Void m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      }
    }
  where
  handleAction = case _ of
    HandleLoginForm auth -> do
      env <- asks _.userEnv
      currentUser <- authenticate env auth
      case currentUser of
        Just user -> do
          -- direct user to auth page here
          pure unit
        Nothing   -> pure unit

  render :: State -> H.ComponentHTML Action ChildSlots m
  render state =
    HH.div 
      [ css "login-form" ]
      [ loginSlot 
      ]

    where
      loginSlot =
        HH.slot
        (SProxy :: SProxy "loginForm")
        unit
        (LoginForm.component)
        unit
        (Just <<< HandleLoginForm)
