let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20221119/packages.dhall
        sha256:de4f89a47f1bd704be63534cf362c55f08a185ac6e803de79e6f2dba2db39194

let overrides = {=}

let additions =
      { express = 
        { dependencies =   
          [ "foreign"
          , "foreign-generic"
          , "node-http"
          , "test-unit"
          , "aff"
          ]
        , repo = "https://github.com/purescript-express/purescript-express"
        , version = "86ec92f0adaa8b01ef49e01d27d1cb999b4cb4cb"
        }
      , foreign-generic =
          { dependencies = [ "effect", "foreign", "foreign-object" ]
          , repo = "https://github.com/working-group-purescript-es/purescript-foreign-generic.git"
          , version ="v0.15.0-updates"
          }
      , timestamp =
        { dependencies = [ "argonaut", "formatters", "precise-datetime" ]
        , repo = "https://github.com/naglalakk/purescript-timestamp"
        , version = "b925c563f13fd0fc8d4d9e7bf954f132fd0b4d69"
        }
      }

in  upstream // overrides // additions
