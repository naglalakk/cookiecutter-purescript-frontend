module AppM where

import Prelude
import Control.Monad.Reader.Trans   (class MonadAsk, ReaderT
                                    ,ask, asks, runReaderT) {% if cookiecutter.user == "y" %}
import Data.Argonaut                (decodeJson)
import Data.Either                  (Either(..))
import Data.Maybe                   (Maybe(..)) {% endif %}
import Effect.Aff                   (Aff)
import Effect.Aff.Class             (class MonadAff)
import Effect.Class                 (class MonadEffect
                                    ,liftEffect)
import Effect.Console               as Console
import Type.Equality                (class TypeEquals, from)
import Routing.Duplex               (print)
import Simple.JSON                  (write)

{% if cookiecutter.user == "y" %}
import Api.Endpoint                 as API
import Api.Request                  (RequestMethod(..)
                                    ,mkRequest) {% endif %}
import Capability.LogMessages       (class LogMessages, logMessage)
import Capability.Navigate          (class Navigate) {% if cookiecutter.user == "y" %}
import Data.Auth                    (APIAuth(..)
                                    ,apiAuth
                                    ,base64encodeUserAuth) {% endif %}
import Data.Environment             (Environment(..), Env)
import Data.Route                   as Route {% if cookiecutter.user == "y" %}
import Resource.User                (class ManageUser) {% endif %}

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
      href = (print Route.routeCodec route)
    -- pushState new destination
    liftEffect $ 
      env.pushInterface.pushState 
      (write {}) 
      href
{% if cookiecutter.user == "y" %}
instance manageUserAppM :: ManageUser AppM where
  loginUser auth = do
    req <- mkRequest 
      { endpoint: API.UserLogin
      , method: Get
      , auth: Just $ Basic $ base64encodeUserAuth auth
      }
    case req of
      Just json -> do
        let user = decodeJson json
        case user of
          Right u -> pure $ Just u
          Left err -> do
            logMessage err
            pure Nothing
      Nothing -> pure Nothing
{% endif %}
