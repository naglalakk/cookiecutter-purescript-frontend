module Form.Utils.Field where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import DOM.HTML.Indexed (HTMLinput)
import DOM.HTML.Indexed.InputType (InputType)
import Form.Validation (FormError, errorToStr)
import Formless (FieldAction, FieldState)
import Halogen.HTML as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type TextInput action output =
  { label :: String
  , state :: FieldState String FormError output
  , action :: FieldAction action String FormError output
  , _type :: InputType
  }

textInput
  :: forall output action slots m
   . TextInput action output
  -> Array (HP.IProp HTMLinput action)
  -> H.ComponentHTML action slots m
textInput { label, state, action, _type } =
  withLabel { label, state } <<< HH.input <<< append
    [ HP.value state.value
    , case state.result of
        Nothing -> HP.attr (HH.AttrName "aria-touched") "false"
        Just (Left _) -> HP.attr (HH.AttrName "aria-invalid") "true"
        Just (Right _) -> HP.attr (HH.AttrName "aria-invalid") "false"
    , HE.onValueInput action.handleChange
    , HE.onBlur action.handleBlur
    , HP.type_ _type
    ]

type Labelled input output =
  { label :: String
  , state :: FieldState input FormError output
  }

-- Attach a label and error text to a form input
withLabel
  :: forall input output action slots m
   . Labelled input output
  -> H.ComponentHTML action slots m
  -> H.ComponentHTML action slots m
withLabel { label, state } html =
  HH.div_
    [ HH.label_ [ HH.text label ]
    , html
    , case state.result of
        Just (Left error) -> HH.small_ [ HH.text $ errorToStr error ]
        _ -> HH.text ""
    ]
