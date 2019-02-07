module Server where

import Prelude hiding (apply)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, use, listenHttp, setProp, get)
import Node.Express.Response (send, render)
import Node.Express.Middleware.Static
import Node.HTTP (Server)

app :: App
app = do
    setProp "views" "static/views"
    setProp "view engine" "pug"
    use (static "static")
    get "/" $ render "index" ""

main :: Effect Server
main = do
    listenHttp app 8080 \_ ->
        log $ "Listening on " <> show 8080

