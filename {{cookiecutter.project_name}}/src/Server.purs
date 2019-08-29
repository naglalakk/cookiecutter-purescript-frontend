module Server where

import Prelude hiding                   (apply)
import Data.Int                         (fromString)
import Data.Maybe                       (fromMaybe)
import Dotenv (loadFile)                as Dotenv
import Effect                           (Effect)
import Effect.Aff                       (launchAff_)
import Effect.Class                     (liftEffect)
import Effect.Console                   (log)
import Node.Express.App                 (App
                                        ,use
                                        ,listenHttp
                                        ,setProp, get)
import Node.Express.Response            (render)
import Node.Express.Middleware.Static   (static)
import Node.Process                     (lookupEnv)

app :: App
app = do
    setProp "views" "static/views"
    setProp "view engine" "pug"
    use (static "static")
    get "/" $ render "index" ""

main :: Effect Unit
main = launchAff_ do
  _ <- Dotenv.loadFile
  liftEffect do
    port <- lookupEnv "PORTNR"
    -- Port defaults to 8080
    let p = fromMaybe "8080" port
    listenHttp app (fromMaybe 8080 $ fromString p) \_ ->
      log $ "Listening on "  <> p

