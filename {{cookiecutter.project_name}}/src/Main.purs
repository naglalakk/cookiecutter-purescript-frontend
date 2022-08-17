module Main where

import Prelude

import Affjax (printError, request)
import Api.Endpoint as API
import Api.Request (RequestMethod(..), defaultRequest)
import AppM (runAppM)
import Component.Router as Router
import Config as Config
import Data.Argonaut (JsonDecodeError, decodeJson)
import Data.Auth (APIAuth(..), readToken)
import Data.Either (Either(..), hush)
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Data.Route (routeCodec)
import Data.String (drop)
import Data.URL (BaseURL(..))
import Data.User (User)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class.Console (logShow)
import Effect.Ref as Ref
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.PushState (makeInterface)
import Store (Store(..), toEnvironment)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody

  let
    baseUrl = BaseURL Config.apiURL
    environment = toEnvironment Config.environment
  pushInterface <- H.liftEffect makeInterface
  user <- H.liftEffect $ Ref.new Nothing

  H.liftEffect readToken >>= traverse_ \token -> do
    let
      requestOptions =
        { endpoint: API.UserLogin
        , method: Get
        , auth: Just $ Basic token
        }
    res <- H.liftAff $ request $ defaultRequest baseUrl requestOptions
    case res of
      Right r -> do
        let
          decodedUser = (decodeJson r.body) :: Either JsonDecodeError User
        case decodedUser of
          Right u -> H.liftEffect $ Ref.write (Just u) user
          Left err -> do
            logShow err
            pure unit
      Left err ->
        logShow $ printError err

  currentUser <- H.liftEffect $ Ref.read user
  let
    initialStore :: Store
    initialStore =
      { baseUrl
      , environment
      , pushInterface
      , currentUser
      }

  rootComponent <- runAppM initialStore Router.component
  halogenIO <- runUI rootComponent unit body

  void $ H.liftEffect $ pushInterface.listen \location -> do
    let
      new = hush $ parse routeCodec $ drop 1 location.pathname
    case new of
      Just r ->
        launchAff_ $ halogenIO.query $ H.mkTell $ Router.Navigate r
      Nothing -> pure unit
