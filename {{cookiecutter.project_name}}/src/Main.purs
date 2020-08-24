module Main where

import Prelude {% if cookiecutter.user == "y" %}
import Affjax                       (request)
import Data.Argonaut                (decodeJson) {% endif %}
import Data.Either                  ({% if cookiecutter.user == "y" %}Either(..), {% endif %}hush) {% if cookiecutter.user == "y" %}
import Data.Foldable                (traverse_) {% endif %}
import Data.Maybe                   (Maybe(..))
import Data.String                  (drop)
import Effect                       (Effect)
import Effect.Aff                   (Aff, launchAff_) {% if cookiecutter.user == "y" %}
import Effect.Aff.Bus               as Bus
import Effect.Ref                   as Ref {% endif %}
import Halogen                      as H
import Halogen.Aff                  as HA
import Halogen.HTML                 as HH
import Halogen.VDom.Driver          (runUI)
import Routing.Duplex               (parse)
import Routing.PushState            (makeInterface)

import AppM                         (runAppM) {% if cookiecutter.user == "y" %}
import Api.Request                  (RequestMethod(..)
                                    ,defaultRequest)
import Api.Endpoint                 as API {% endif %}
import Component.Router             as Router
import Config                       (environment, apiURL) {% if cookiecutter.user == "y" %}
import Data.Auth                    (APIAuth(..)
                                    ,readToken) {% endif %}
import Data.Environment             (Env {% if cookiecutter.user == "y" %}
                                    ,UserEnv {% endif %}
                                    ,toEnvironment)
import Data.Route                   (routeCodec) {% if cookiecutter.user == "y" %}
import Data.User                    (User) {% endif %}
import Data.URL                     (BaseURL(..))

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody {% if cookiecutter.user == "y" %}
  currentUser <- H.liftEffect $ Ref.new Nothing
  userBus <- H.liftEffect Bus.make {% endif %}
  interface <- H.liftEffect makeInterface 
  {% if cookiecutter.user == "y" %}
  H.liftEffect readToken >>= traverse_ \token -> do
    let 
      requestOptions = 
        { endpoint: API.UserLogin
        , method: Get 
        , auth: Just $ Basic token
        }
    res <- H.liftAff $ request $ defaultRequest (BaseURL apiURL) requestOptions

    case (hush res.body) of
      Just json -> do
        let 
          user = (decodeJson json) :: Either String User
        case user of
          Right u -> H.liftEffect $ Ref.write (Just u) currentUser
          Left err -> pure unit
      Nothing -> pure unit
  {% endif %}
  let 
    environ = toEnvironment environment
    url     = BaseURL apiURL
    env :: Env
    env = 
      { environment: environ
      , apiURL: url {% if cookiecutter.user == "y" %}
      , userEnv: userEnv {% endif %}
      , pushInterface: interface
      } {% if cookiecutter.user == "y" %}
      where
        userEnv :: UserEnv
        userEnv = { currentUser, userBus } {% endif %}

    rootComponent :: H.Component HH.HTML Router.Query Unit Void Aff
    rootComponent = H.hoist (runAppM env) Router.component

  halogenIO <- runUI rootComponent unit body

  void $ H.liftEffect $ interface.listen \location -> do
    let
      new  = hush $ parse routeCodec $ drop 1 location.pathname
    case new of
      Just r -> launchAff_ $ halogenIO.query $ H.tell $ Router.Navigate r
      Nothing -> pure unit
  pure unit
