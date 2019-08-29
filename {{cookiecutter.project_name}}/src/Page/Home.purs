module Page.Home where

import Prelude
import Data.Const                   (Const)
import Data.Maybe                   (Maybe(..))
import Data.Symbol                  (SProxy(..))
import Halogen                      as H
import Halogen.HTML                 as HH

import Component.Button as Button
import Component.Utils              (OpaqueSlot)

type State = Maybe Int

data Action = NoAction

type ChildSlots = 
  ( button :: OpaqueSlot Unit)

component :: forall m. H.Component HH.HTML (Const Void) Unit Void m
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
      , HH.slot (SProxy :: _ "button") unit Button.component unit absurd
      ]
