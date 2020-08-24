module Component.Router where

import Prelude
{% if cookiecutter.user == "y" %}
import Control.Monad.Reader             (class MonadAsk, asks) {% endif %}
import Data.Either                      (hush) {% if cookiecutter.user == "y" %}
import Data.Foldable                    (elem) {% endif %}
import Data.Maybe                       (Maybe(..)
                                        ,fromMaybe
                                        {% if cookiecutter.user == "y" %},isJust{% endif %})
import Data.String                      (drop)
import Data.Symbol                      (SProxy(..))
import Effect.Aff.Class                 (class MonadAff) {% if cookiecutter.user == "y" %}
import Effect.Ref                       as Ref {% endif %}
import Halogen                          (liftEffect)
import Halogen                          as H
import Halogen.HTML                     as HH
import Routing.Duplex                   as RD
import Web.HTML                         (window)
import Web.HTML.Window                  as Window
import Web.HTML.Location                as Location

import Capability.Navigate              (class Navigate)
import Component.Utils                  (OpaqueSlot{% if cookiecutter.user == "y" %}, busEventSource{% endif %}) {% if cookiecutter.user == "y" %}
import Data.Environment                 (UserEnv) {% endif %}
import Data.Route                       (Route(..), routeCodec) {% if cookiecutter.user == "y" %}
import Data.User                        (User) {% endif %}
import Page.Home                        as Home {% if cookiecutter.user == "y" %}
import Page.Login                       as Login
import Resource.User                    (class ManageUser) {% endif %}

type State = 
  { route :: Maybe Route {% if cookiecutter.user == "y" %}
  , currentUser :: Maybe User {% endif %}
  }

data Query a
  = Navigate Route a 

data Action 
  = Initialize {% if cookiecutter.user == "y" %}
  | HandleUserBus (Maybe User) {% endif %}

type ChildSlots = 
  ( home :: OpaqueSlot Unit {% if cookiecutter.user == "y" %}
  , login :: OpaqueSlot Unit {% endif %}
  )

component
  :: forall m {% if cookiecutter.user == "y" %}r{% endif %}
   . MonadAff m {% if cookiecutter.user == "y" %}
  => MonadAsk { userEnv :: UserEnv | r } m
  => ManageUser m {% endif %}
  => Navigate m
  => H.Component HH.HTML Query Unit Void m 
component = H.mkComponent 
  { initialState: \_ -> 
    { route: Nothing {% if cookiecutter.user == "y" %}
    , currentUser: Nothing {% endif %}
    }
  , render
  , eval: H.mkEval $ H.defaultEval
      { handleQuery = handleQuery
      , handleAction = handleAction
      , initialize = Just Initialize
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
        initialRoute = hush $ (RD.parse routeCodec finalPath) {% if cookiecutter.user == "y" %}
      { currentUser, userBus } <- asks _.userEnv
      _ <- H.subscribe (HandleUserBus <$> busEventSource userBus)
      mbUser <- H.liftEffect $ Ref.read currentUser {% endif %}
      H.modify_ _ { route = Just $ fromMaybe Home initialRoute {% if cookiecutter.user == "y" %}
                  , currentUser = mbUser {% endif %}
                  }
    {% if cookiecutter.user == "y" %}
    HandleUserBus user -> H.modify_ _ { currentUser = user } {% endif %}

  handleQuery :: forall a. Query a -> H.HalogenM State Action ChildSlots Void m (Maybe a)
  handleQuery = case _ of
    Navigate dest a -> do {% if cookiecutter.user != "y" %}
      { route } <- H.get
      when (route /= Just dest) do
         H.modify_ _ { route = Just dest }
      pure (Just a) {% else %}
      { route, currentUser } <- H.get 
      when (route /= Just dest) do
        case (isJust currentUser && dest `elem` [ Login ]) of
          false -> H.modify_ _ { route = Just dest }
          _ -> pure unit
      pure (Just a) {% endif %}
  {% if cookiecutter.user == "y" %}
  authorize :: Maybe User -> H.ComponentHTML Action ChildSlots m -> H.ComponentHTML Action ChildSlots m
  authorize mbUser html = case mbUser of
    Nothing ->
      HH.slot (SProxy :: _ "login") unit Login.component { redirect: false } absurd
    Just _ ->
      html {% endif %}
  
  render :: State -> H.ComponentHTML Action ChildSlots m
  render { route{% if cookiecutter.user == "y" %}, currentUser {% endif %}} = case route of
    Just Home -> 
      HH.slot (SProxy :: _ "home") unit Home.component unit absurd {% if cookiecutter.user == "y" %}
    Just Login ->
      HH.slot (SProxy :: _ "login") unit Login.component { redirect: true } absurd {% endif %}
    Nothing ->
      HH.div_ [ HH.text "Oh no! That page wasn't found." ]
