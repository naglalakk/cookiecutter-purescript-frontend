{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources = [ "src/**/*.purs", "test/**/*.purs" ]
, name = "{{ cookiecutter.project_name }}"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut"
  , "argonaut-codecs"
  , "argonaut-core"
  , "b64"
  , "console"
  , "const"
  , "css"
  , "dom-indexed"
  , "dotenv"
  , "effect"
  , "either"
  , "encoding"
  , "express"
  , "foldable-traversable"
  , "halogen"
  , "halogen-formless"
  , "halogen-store"
  , "http-methods"
  , "integers"
  , "maybe"
  , "newtype"
  , "node-process"
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
