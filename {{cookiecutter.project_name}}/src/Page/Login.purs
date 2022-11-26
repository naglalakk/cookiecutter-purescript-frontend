module Page.Login where

import Prelude
import Api.Utils (authenticate)
import Capability.Navigate (class Navigate, navigate)
import Component.HTML.Utils (css)
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Auth (UserAuth)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Route (Route(Home))
import Effect.Aff.Class (class MonadAff)
import Form.Login as LoginForm
import Halogen as H
import Halogen.HTML as HH
import Halogen.Store.Monad (class MonadStore)
import Resource.User (class ManageUser)
import Store as Store
import Type.Proxy (Proxy(..))

type State =
  { redirect :: Boolean }

type Input =
  { redirect :: Boolean }

data Action = HandleLoginForm UserAuth

type ChildSlots =
  ( loginForm :: LoginForm.Slot Unit
  )

component
  :: forall q o m
   . Monad m
  => MonadAff m
  => MonadStore Store.Action Store.Store m
  => ManageUser m
  => Navigate m
  => H.Component q Input o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = handleAction
        }
    }
  where
  handleAction :: forall o. Action -> H.HalogenM State Action ChildSlots o m Unit
  handleAction = case _ of
    HandleLoginForm auth -> do
      currentUser <- authenticate auth
      case currentUser of
        Just user -> do
          -- Navigate user to logged-in page
          navigate Home
        Nothing -> pure unit

  render :: State -> H.ComponentHTML Action ChildSlots m
  render state =
    HH.div
      [ css "login-form" ]
      [ loginSlot
      ]

    where
    loginSlot =
      HH.slot
        (Proxy :: Proxy "loginForm")
        unit
        (LoginForm.component)
        unit
        HandleLoginForm
