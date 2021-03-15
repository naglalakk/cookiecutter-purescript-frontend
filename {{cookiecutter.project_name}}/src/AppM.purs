module AppM where

import Prelude

import Affjax (printError)
import Api.Endpoint as API
import Api.Request (RequestMethod(..), mkRequest)
import Capability.LogMessages (class LogMessages, logMessage)
import Capability.Navigate (class Navigate)
import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.Argonaut (decodeJson, printJsonDecodeError)
import Data.Auth (APIAuth(..), apiAuth, base64encodeUserAuth)
import Data.Either (Either(..))
import Data.Environment (Environment(..), Env)
import Data.Maybe (Maybe(..))
import Data.Route as Route
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Resource.User (class ManageUser)
import Routing.Duplex (print)
import Simple.JSON (write)
import Type.Equality (class TypeEquals, from)

newtype AppM a = AppM (ReaderT Env Aff a)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from

instance logMessagesAppM :: LogMessages AppM where
  logMessage log = do 
    env <- ask
    liftEffect case env.environment of
      Production -> pure unit
      _ -> Console.log log

instance navigateAppM :: Navigate AppM where
  navigate route = do
    -- Get our PushStateInterface instance from env
    env <- ask
    let 
      href = "/" <> (print Route.routeCodec route)
    -- pushState new destination
    liftEffect $ 
      env.pushInterface.pushState 
      (write {}) 
      href

instance manageUserAppM :: ManageUser AppM where
  loginUser auth = do
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
