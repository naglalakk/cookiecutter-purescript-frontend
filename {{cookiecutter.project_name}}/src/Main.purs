module Main where

import Prelude
import Data.Maybe               (Maybe(..))
import Effect                   (Effect)
import Effect.Aff               (Aff, launchAff_)
import Halogen                  as H
import Halogen.Aff              as HA
import Halogen.HTML             as HH
import Halogen.VDom.Driver      (runUI)
import Routing.Duplex           (parse)
import Routing.Hash             (matchesWith)

import AppM                     (runAppM)
import Component.Router         as Router
import Config                   (environment, apiURL)
import Data.Environment         (Env, toEnvironment)
import Data.Route               (routeCodec)
import Data.URL                 (BaseURL(..))

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody

  let 
    environ = toEnvironment environment
    url     = BaseURL apiURL

    env :: Env
    env = { environment: environ
          , apiURL: url
          }

    rootComponent :: H.Component HH.HTML Router.Query Unit Void Aff
    rootComponent = H.hoist (runAppM env) Router.component

  halogenIO <- runUI rootComponent unit body

  void $ H.liftEffect $ matchesWith (parse routeCodec) \old new ->
    when (old /= Just new) do
      launchAff_ $ halogenIO.query $ H.tell $ Router.Navigate new
  
  pure unit
