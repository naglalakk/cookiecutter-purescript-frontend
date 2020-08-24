module Component.HTML.Utils where

import Prelude

import Data.Maybe               (Maybe(..))
import Data.String              (splitAt)
import Halogen.HTML             as HH
import Halogen.HTML.Properties  as HP
import Routing.Duplex           (print)

import Data.Route               (Route, routeCodec)


css :: forall r i. String -> HH.IProp ( class :: String | r ) i
css = HP.class_ <<< HH.ClassName

classes_ :: forall p i. Array String -> HH.IProp (class :: String | i) p
classes_ = HP.classes <<< map HH.ClassName

type Part = { before :: String, after :: String }

safeHref :: forall r i. Route -> HH.IProp ( href :: String | r) i
safeHref = HP.href <<< append "/" <<< print routeCodec

maybeElem :: forall p i a. Maybe a -> (a -> HH.HTML p i) -> HH.HTML p i
maybeElem (Just x) f = f x
maybeElem _ _ = HH.text ""

-- Takes a String, Int
-- and splits the string at index = n
splitStr :: forall p i. String -> Int -> (Part -> HH.HTML p i) -> HH.HTML p i
splitStr s n f = f parts
  where
    parts = splitAt n s

whenElem :: forall p i. Boolean -> (Unit -> HH.HTML p i) -> HH.HTML p i
whenElem cond f = if cond then f unit else HH.text ""

withLabel :: forall p i. String -> HH.HTML p i  ->  HH.HTML p i
withLabel str html =
  HH.div
    []
    [ HH.label
      [ css "label" ]
      [ HH.text str ]
    , html
    ]
