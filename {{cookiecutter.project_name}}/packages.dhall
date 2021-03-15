{-
Welcome to Spacchetti local packages!

Below are instructions for how to edit this file for most use
cases, so that you don't need to know Dhall to use it.

## Warning: Don't Move This Top-Level Comment!

Due to how `dhall format` currently works, this comment's
instructions cannot appear near corresponding sections below
because `dhall format` will delete the comment. However,
it will not delete a top-level comment like this one.

## Use Cases

Most will want to do one or both of these options:
1. Override/Patch a package's dependency
2. Add a package not already in the default package set

This file will continue to work whether you use one or both options.
Instructions for each option are explained below.

### Overriding/Patching a package

Purpose:
- Change a package's dependency to a newer/older release than the
    default package set's release
- Use your own modified version of some dependency that may
    include new API, changed API, removed API by
    using your custom git repo of the library rather than
    the package set's repo

Syntax:
Replace the overrides' "{=}" (an empty record) with the following idea
The "//" or "⫽" means "merge these two records and
  when they have the same value, use the one on the right:"
-------------------------------
let override =
  { packageName =
      upstream.packageName ⫽ { updateEntity1 = "new value", updateEntity2 = "new value" }
  , packageName =
      upstream.packageName ⫽ { version = "v4.0.0" }
  , packageName =
      upstream.packageName // { repo = "https://www.example.com/path/to/new/repo.git" }
  }
-------------------------------

Example:
-------------------------------
let overrides =
  { halogen =
      upstream.halogen ⫽ { version = "master" }
  , halogen-vdom =
      upstream.halogen-vdom ⫽ { version = "v4.0.0" }
  }
-------------------------------

### Additions

Purpose:
- Add packages that aren't alread included in the default package set

Syntax:
Replace the additions' "{=}" (an empty record) with the following idea:
-------------------------------
let additions =
  { "package-name" =
       mkPackage
         [ "dependency1"
         , "dependency2"
         ]
         "https://example.com/path/to/git/repo.git"
         "tag ('v4.0.0') or branch ('master')"
  , "package-name" =
       mkPackage
         [ "dependency1"
         , "dependency2"
         ]
         "https://example.com/path/to/git/repo.git"
         "tag ('v4.0.0') or branch ('master')"
  , etc.
  }
-------------------------------

Example:
-------------------------------
let additions =
  { benchotron =
      mkPackage
        [ "arrays"
        , "exists"
        , "profunctor"
        , "strings"
        , "quickcheck"
        , "lcg"
        , "transformers"
        , "foldable-traversable"
        , "exceptions"
        , "node-fs"
        , "node-buffer"
        , "node-readline"
        , "datetime"
        , "now"
        ]
        "https://github.com/hdgarrood/purescript-benchotron.git"
        "v7.0.0"
  }
-------------------------------
-}

let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20210118/packages.dhall sha256:a59c5c93a68d5d066f3815a89f398bcf00e130a51cb185b2da29b20e2d8ae115


let overrides =
  { css =
          upstream.css
      //  { repo =
              "https://github.com/slamdata/purescript-css"
          , version =
              "70ad3b95c070e79b1946aafc84cb446a17a3b695"
          }
  }

let additions = 
  { argonaut =
      { dependencies = 
          ["argonaut-codecs"
          ,"argonaut-core"
          ,"argonaut-traversals"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut"
      , version = 
        "2b81ce16b4c0e8cac0be88b4bf616523b6ddda56"
      }
  , argonaut-codecs =
      { dependencies =
          ["argonaut-core"
          ,"arrays"
          ,"effect"
          ,"foreign-object"
          ,"identity"
          ,"integers"
          ,"maybe"
          ,"nonempty"
          ,"ordered-collections"
          ,"record"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut-codecs/"
      , version = 
          "9b00fcc6b04bd999d3fd3b9de2ae830bff473a71"
      }
  , argonaut-traversals = 
      { dependencies = 
          ["argonaut-core"
          ,"argonaut-codecs"
          ,"profunctor-lenses"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut-traversals"
      , version = 
          "9543b517011a4dbc66dfd5cd4d8d774aa620b764"
      }
  , express  = 
    { dependencies = 
      [ "foreign"
      , "foreign-generic"
      , "node-http"
      , "test-unit"
      , "aff"
      ]
    , repo = 
      "https://github.com/nkly/purescript-express"
    , version = 
      "b0d3d31703a02a7dddc48fa23669bebe6de85e90"
    }
  , halogen-formless = 
    { dependencies = 
      [ "variant"
      , "heterogeneous"
      , "generics-rep"
      , "profunctor-lenses"
      ]
    , repo = 
      "https://github.com/thomashoneyman/purescript-halogen-formless.git"
    , version = 
      "07f877c99420b33dd8813cbf8ab2c30ca40bbb49"
    }
  , halogen-select = 
    { dependencies = 
      ["halogen", "record"]
    , repo = 
      "https://github.com/citizennet/purescript-halogen-select"
    , version = 
      "467b35fa5dd05d64dbdbcab77442153f729bd0a8"
    }
  , precise-datetime =
    { dependencies =
      [ "arrays"
      , "console"
      , "datetime"
      , "either"
      , "enums"
      , "foldable-traversable"
      , "formatters"
      , "integers"
      , "js-date"
      , "lists"
      , "maybe"
      , "newtype"
      , "strings"
      , "tuples"
      , "unicode"
      , "numbers"
      , "decimals"
      ]
    , repo = 
      "https://github.com/awakesecurity/purescript-precise-datetime"
    , version = 
      "2355b3471b758e16d17078e09bb79ee26d82b90a"
    }
  , routing-duplex = 
    { dependencies = 
      [ "typelevel-prelude"
      , "arrays"
      , "globals"
      , "strings"
      , "lazy"
      , "profunctor"
      ]
    , repo = 
      "https://github.com/natefaubion/purescript-routing-duplex"
    , version = 
      "150d92bab24e0f8ad23f84e4a3e24c6c9ebc5ac6"
    }
  , timestamp =
    { dependencies = 
      ["argonaut"
      ,"formatters"
      ,"precise-datetime"]
    , repo = 
      "https://github.com/naglalakk/purescript-timestamp"
    , version = 
      "fc494eef323beb9e084d31c2b78fcd197de36c10"
    }
  }

in  upstream ⫽ overrides ⫽ additions
