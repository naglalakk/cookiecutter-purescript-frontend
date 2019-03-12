module Main where

import Prelude
import Data.Either              (hush)
import Data.Maybe               (Maybe(..))
import Effect                   (Effect)
import Effect.Aff               (Aff, launchAff_)
import Halogen                  as H
import Halogen.Aff              as HA
import Halogen.HTML             as HH
import Halogen.VDom.Driver      (runUI)
import Routing.Duplex           (parse)
import Routing.Hash             (getHash, matchesWith)

import AppM                     (Environment(..)
                                , Env(..), runAppM)
import Api.Request              (BaseURL(..))
import Component.Router         as Router
import Data.Route               (Route, routeCodec)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  initialHash <- H.liftEffect $ getHash

  let 
    baseUrl = BaseURL "http://localhost:8080"
    logLevel = Development
  
    environment :: Env
    environment = { logLevel, baseUrl }

    rootComponent :: H.Component HH.HTML Router.Query Router.Input Void Aff
    rootComponent = H.hoist (runAppM environment) Router.component

    initialRoute :: Maybe Route
    initialRoute = hush $ parse routeCodec initialHash

  halogenIO <- runUI rootComponent initialRoute body

  void $ H.liftEffect $ matchesWith (parse routeCodec) \old new ->
    when (old /= Just new) do
      launchAff_ $ halogenIO.query $ H.action $ Router.Navigate new
  
  pure unit
