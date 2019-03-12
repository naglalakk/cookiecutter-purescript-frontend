module Component.Router where

import Prelude

import Data.Either.Nested               (Either1)
import Data.Functor.Coproduct.Nested    (Coproduct1)
import Data.Maybe                       (fromMaybe, Maybe(..))
import Effect.Aff.Class                 (class MonadAff)
import Halogen                          as H
import Halogen.Component.ChildPath      as CP
import Halogen.HTML                     as HH

import Page.Home                        as Home
import Data.Route                       (Route(..))

type State = 
  { route :: Route }

data Query a
  = Navigate Route a 

type Input = 
  Maybe Route

type ChildQuery = Coproduct1
  Home.Query

type ChildSlot = Either1
  Unit

component
  :: forall m 
   . MonadAff m
  => H.Component HH.HTML Query Input Void m 
component = 
  H.parentComponent
  { initialState: \initialRoute -> { route: fromMaybe Home initialRoute }
  , render
  , eval
  , receiver: const Nothing
  }
  where
    eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Void m
    eval (Navigate dest a) = do
      { route } <- H.get
      when (route /= dest) do
         H.modify_ _ { route = dest }
      pure a

    render :: State -> H.ParentHTML Query ChildQuery ChildSlot m 
    render { route } = case route of
      Home -> 
        HH.slot' CP.cp1 unit Home.component unit absurd
