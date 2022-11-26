{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources = [ "src/**/*.purs", "test/**/*.purs" ]
, name = "test1"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "argonaut"
  , "argonaut-codecs"
  , "argonaut-core"
  , "b64"
  , "console"
  , "const"
  , "css"
  , "dom-indexed"
  , "effect"
  , "either"
  , "encoding"
  , "foldable-traversable"
  , "halogen"
  , "halogen-formless"
  , "halogen-store"
  , "http-methods"
  , "maybe"
  , "newtype"
  , "prelude"
  , "psci-support"
  , "refs"
  , "routing"
  , "routing-duplex"
  , "safe-coerce"
  , "simple-json"
  , "spec"
  , "strings"
  , "timestamp"
  , "transformers"
  , "tuples"
  , "web-html"
  , "web-storage"
  , "web-xhr"
  ]
, packages = ./packages.dhall
}
