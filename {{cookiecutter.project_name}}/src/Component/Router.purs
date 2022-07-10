module Component.Router where

import Prelude
import Capability.Navigate (class Navigate)
import Component.Utils (OpaqueSlot)
import Data.Either (hush)
import Data.Foldable (elem)
import Data.Maybe (Maybe(..), fromMaybe, isJust)
import Data.Route (Route(..), routeCodec)
import Data.String (drop)
import Data.User (User)
import Effect.Aff.Class (class MonadAff)
import Effect.Ref as Ref
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectEq)
import Page.Home as Home
import Page.Login as Login
import Resource.User (class ManageUser)
import Routing.Duplex as RD
import Store as Store
import Type.Proxy (Proxy(..))
import Web.HTML (window)
import Web.HTML.Window as Window
import Web.HTML.Location as Location


type State = 
  { route :: Maybe Route
  , currentUser :: Maybe User
  }

data Query a
  = Navigate Route a 

data Action 
  = Initialize
  | Receive (Connected (Maybe User) Unit)

type ChildSlots = 
  ( home :: OpaqueSlot Unit
  , login :: OpaqueSlot Unit
  )

component
  :: forall m
   . MonadAff m
  => MonadStore Store.Action Store.Store m
  => ManageUser m
  => Navigate m
  => H.Component Query Unit Void m 
component = connect (selectEq _.currentUser) $ H.mkComponent 
  { initialState: \{ context: currentUser } -> 
    { route: Nothing
    , currentUser: currentUser
    }
  , render
  , eval: H.mkEval $ H.defaultEval
      { handleQuery = handleQuery
      , handleAction = handleAction
      , initialize = Just Initialize
      , receive = Just <<< Receive
      }
  }
  where
  handleAction :: Action -> H.HalogenM State Action ChildSlots Void m Unit
  handleAction = case _ of
    Initialize -> do
      w <- H.liftEffect window
      location <- liftEffect $ Window.location w
      p <- H.liftEffect $ Location.pathname location
      let 
        finalPath = drop 1 p
        initialRoute = hush $ (RD.parse routeCodec finalPath)
      H.modify_ _ 
        { route = Just $ fromMaybe Home initialRoute
        }
    
    Receive { context: currentUser } ->
      H.modify_ _ { currentUser = currentUser }

  handleQuery :: forall a. Query a -> H.HalogenM State Action ChildSlots Void m (Maybe a)
  handleQuery = case _ of
    Navigate dest a -> do
      
      { route, currentUser } <- H.get
      when (route /= Just dest) do
        case (isJust currentUser && dest `elem` [ Login ]) of
          false -> H.modify_ _ { route = Just dest }
          _ -> pure unit
      pure (Just a)

  authorize :: Maybe User -> H.ComponentHTML Action ChildSlots m -> H.ComponentHTML Action ChildSlots m
  authorize user html = case user of
    Nothing ->
      HH.slot (Proxy :: _ "login") unit Login.component { redirect: false } absurd
    Just _ ->
      html
  
  render :: State -> H.ComponentHTML Action ChildSlots m
  render { route, currentUser } = case route of
    Just Home -> 
      HH.slot (Proxy :: _ "home") unit Home.component unit absurd
    Just Login ->
      HH.slot (Proxy :: _ "login") unit Login.component { redirect: true } absurd
    Nothing ->
      HH.div_ [ HH.text "Oh no! That page wasn't found." ]
