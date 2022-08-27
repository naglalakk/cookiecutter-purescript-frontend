module Form.Login where

import Prelude
import Component.HTML.Utils (css)
import Data.Auth (UserAuth(..))
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Form.Validation (FormError, validateRequiredStr)
import Form.Utils.Field (textInput)
import Formless as F
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import DOM.HTML.Indexed.InputType (InputType(..))

type LoginForm :: (Type -> Type -> Type -> Type) -> Row Type
type LoginForm f =
  ( username :: f String FormError String
  , password :: f String FormError String
  )

type FormContext = F.FormContext (LoginForm F.FieldState) (LoginForm (F.FieldAction Action)) Unit Action
type FormlessAction = F.FormlessAction (LoginForm F.FieldState)

data Action
  = Receive FormContext
  | Eval FormlessAction

type Slot = H.Slot (Const Void) UserAuth

component :: forall query m. Monad m => MonadAff m => H.Component query Unit UserAuth m
component = F.formless { liftAction: Eval } mempty $ H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval $ H.defaultEval
      { receive = Just <<< Receive
      , handleAction = handleAction
      , handleQuery = handleQuery
      }
  }
  where
  handleAction :: Action -> H.HalogenM _ _ _ _ _ Unit
  handleAction = case _ of
    Receive context -> H.put context
    Eval action -> F.eval action

  handleQuery :: forall a. F.FormQuery _ _ _ _ a -> H.HalogenM _ _ _ _ _ (Maybe a)
  handleQuery = do
    let
      validation :: { | LoginForm F.FieldValidation }
      validation =
        { username: validateRequiredStr
        , password: validateRequiredStr
        }

      handleSuccess :: { username :: String, password :: String } -> H.HalogenM _ _ _ _ _ Unit
      handleSuccess auth = F.raise $ UserAuth auth

    F.handleSubmitValidate handleSuccess F.validate validation

  render :: FormContext -> H.ComponentHTML Action () m
  render { formActions, fields, actions } =
    HH.form
      [ HE.onSubmit formActions.handleSubmit ]
      [ textInput
          { label: "Username"
          , state: fields.username
          , action: actions.username
          , _type: InputText
          }
          []
      , textInput
          { label: "Password"
          , state: fields.password
          , action: actions.password
          , _type: InputPassword
          }
          []
      , HH.input
          [ css "button"
          , HP.type_ HP.InputSubmit
          , HP.value "Login"
          ]
      ]
