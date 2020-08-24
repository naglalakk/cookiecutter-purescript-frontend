module Form.Login where 

import Prelude
import Data.Const                   (Const)
import Data.Maybe                   (Maybe(..))
import Data.Newtype                 (class Newtype)
import Effect.Aff.Class             (class MonadAff)
import Formless                     as F
import Halogen                      as H
import Halogen.HTML                 as HH
import Halogen.HTML.Events          as HE
import Halogen.HTML.Properties      as HP

import Component.HTML.Utils         (withLabel, css)
import Data.Auth                    (UserAuth(..), Password)
import Data.User                    (Username)
import Form.Error                   (FormError)
import Form.Validation              (validateUsername
                                    ,validatePassword)

newtype LoginForm r f = LoginForm (r
  ( username :: f FormError String Username
  , password :: f FormError String Password
  ))

derive instance newtypeLoginForm :: Newtype (LoginForm r f) _

prx :: F.SProxies LoginForm 
prx = F.mkSProxies (F.FormProxy :: F.FormProxy LoginForm)

type Input      = Unit
type Query      = Const Void
type Output     = UserAuth
type ChildSlots = ()


component :: forall m
           . Monad m
          => MonadAff m
          => F.Component LoginForm Query ChildSlots Input Output m
component = F.component (const input) F.defaultSpec
  { render = render
  , handleEvent = handleEvent
  }
  where

  input :: F.Input' LoginForm m
  input = 
    { initialInputs: Nothing
    , validators: LoginForm
      { username: validateUsername
      , password: validatePassword
      }
    }

  handleEvent = case _ of
    F.Submitted outputs -> H.raise $ UserAuth $ F.unwrapOutputFields outputs
    _ -> pure unit

  render st = 
    HH.div
      [ css "login-form" ]
      [ withLabel "Username*" (HH.input
        [ css "text-input"
        , HE.onValueInput $ Just <<< F.setValidate prx.username
        ])
      , withLabel "Password*" (HH.input
        [ css "text-input"
        , HE.onValueInput $ Just <<< F.setValidate prx.password
        , HP.type_ HP.InputPassword
        ])
      , HH.button
        [ css "button" 
        , HE.onClick \_ -> Just F.submit
        ]
        [ HH.text "Login" ]
      ]
