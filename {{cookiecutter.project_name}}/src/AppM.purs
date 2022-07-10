module AppM where

import Prelude


import Affjax (printError)
import Api.Endpoint as API
import Api.Request (RequestMethod(..), mkRequest)
import Capability.LogMessages (class LogMessages, logMessage)
import Capability.Navigate (class Navigate, navigate)
import Data.Argonaut (decodeJson, printJsonDecodeError) 
import Data.Auth (APIAuth(..), apiAuth, base64encodeUserAuth, removeToken)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Route as Route
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Halogen as H
import Halogen.Store.Monad (class MonadStore, StoreT, getStore, runStoreT, updateStore)
import Resource.User (class ManageUser)
import Routing.Duplex (print)
import Simple.JSON (write)
import Safe.Coerce (coerce)
import Store (Action, Store)
import Store as Store

newtype AppM a = AppM (StoreT Store.Action Store.Store Aff a)

runAppM :: forall q i o. Store.Store -> H.Component q i o AppM -> Aff (H.Component q i o Aff)
runAppM store = runStoreT store Store.reduce <<< coerce


derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM
derive newtype instance monadStoreAppM :: MonadStore Action Store AppM

instance logMessagesAppM :: LogMessages AppM where
  logMessage log = do 
    { environment } <- getStore
    liftEffect case environment of
      Store.Production -> pure unit
      _ -> Console.log log

instance navigateAppM :: Navigate AppM where
  navigate route = do
    -- Get our PushStateInterface instance from env
    { pushInterface } <- getStore
    let 
      href = "/" <> (print Route.routeCodec route)
    -- pushState new destination
    liftEffect $ 
      pushInterface.pushState 
      (write {}) 
      href
 

instance manageUserAppM :: ManageUser AppM where
  login auth = do
    res <- mkRequest 
      { endpoint: API.UserLogin
      , method: Get
      , auth: Just $ Basic $ base64encodeUserAuth auth
      }
    case res of
      Right json -> do
        let user = decodeJson json.body
        case user of
          Right u -> pure $ Just u
          Left err -> do
            logMessage $ printJsonDecodeError err
            pure Nothing
      Left err -> do
        logMessage $ printError err
        pure Nothing

  logout = do
    liftEffect $ removeToken
    updateStore Store.LogoutUser
    navigate Route.Home
