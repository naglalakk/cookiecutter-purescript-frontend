let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.7-20220418/packages.dhall
        sha256:2523a5659d0f3b198ffa2f800da147e0120578842e492a7148e4b44f357848b3

let overrides = {=}

let additions = 
  { timestamp  =
      { dependencies = 
        ["argonaut"
        ,"formatters"
        ,"precise-datetime"]
      , repo = 
        "https://github.com/naglalakk/purescript-timestamp"
      , version = 
        "b925c563f13fd0fc8d4d9e7bf954f132fd0b4d69"
      }
  }

in  upstream ⫽ overrides ⫽ additions
