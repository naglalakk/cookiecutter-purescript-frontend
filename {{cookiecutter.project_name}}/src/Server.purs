module Server where

import Prelude hiding (apply)
import Data.Int (fromString)
import Data.Maybe (fromMaybe)
import Dotenv (loadFile) as Dotenv
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.Express.App (App, useAt, listenHttp, get)
import Node.Express.Response (sendFile)
import Node.Express.Middleware.Static (static)
import Node.Process (lookupEnv)
import Store (Environment(..), toEnvironment)

app :: Environment -> App
app env = do
    case env of
      Development -> useAt "/static" (static "static")
      _ -> pure unit
    -- route all requests to the same template
    get "*" $ sendFile "static/views/index.html"

main :: Effect Unit
main = launchAff_ do
  _ <- Dotenv.loadFile
  liftEffect do
    port <- lookupEnv "PORTNR"
    env  <- lookupEnv "ENVIRONMENT"
    -- Port defaults to 8080
    let 
      p   = fromMaybe "8080" port
      envStr = fromMaybe "Development" env
    listenHttp (app $ toEnvironment envStr) (fromMaybe 8080 $ fromString p) \_ ->
      log $ "Listening on "  <> p
