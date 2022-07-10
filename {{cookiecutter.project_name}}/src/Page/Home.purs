module Page.Home where

import Prelude
import Component.Button as Button
import Component.Utils (OpaqueSlot)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Type.Proxy(Proxy(..))


type State = Maybe Int

data Action = NoAction

type ChildSlots = 
  ( button :: OpaqueSlot Unit)

component :: forall q o m. H.Component q Unit o m
component =
  H.mkComponent
    { initialState: const Nothing
    , render
    , eval: H.mkEval H.defaultEval
    }
  where

  render :: State -> H.ComponentHTML Action ChildSlots m
  render state =
    HH.div_
      [ HH.h1_
        [ HH.text "Button" ]
      , HH.slot (Proxy :: _ "button") unit Button.component unit absurd
      ]
