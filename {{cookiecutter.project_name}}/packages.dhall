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

let mkPackage =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.3-20190818/src/mkPackage.dhall sha256:0b197efa1d397ace6eb46b243ff2d73a3da5638d8d0ac8473e8e4a8fc528cf57

let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.3-20190818/src/packages.dhall sha256:c95c4a8b8033a48a350106b759179f68a695c7ea2208228c522866fd43814dc8

let overrides =
  { halogen =
      upstream.halogen ⫽ { version = "v5.0.0-rc.4" }
  , halogen-vdom =
      upstream.halogen-vdom ⫽ { version = "v6.1.0" }
  , dom-indexed = 
      upstream.dom-indexed ⫽ { version = "v7.0.0" }
  , css =
          upstream.css
      //  { repo =
              "https://github.com/slamdata/purescript-css"
          , version =
              "70ad3b95c070e79b1946aafc84cb446a17a3b695"
          }
  }

let additions = 
  { express  = 
      mkPackage 
      [ "foreign"
      , "foreign-generic"
      , "node-http"
      , "test-unit"
      , "aff"
      ]
      "https://github.com/nkly/purescript-express"
      "master"
  , halogen-formless = 
      mkPackage 
      [ "halogen-renderless"
      , "variant"
      , "heterogeneous"
      , "generics-rep"
      ]
      "https://github.com/thomashoneyman/purescript-halogen-formless.git"
      "master"
  , halogen-select = 
      mkPackage
      ["halogen", "record"]
      "https://github.com/citizennet/purescript-halogen-select"
      "467b35fa5dd05d64dbdbcab77442153f729bd0a8"
  , halogen-renderless = 
      mkPackage
      ["control"]
      "https://github.com/thomashoneyman/purescript-halogen-renderless"
      "master"
  , precise-datetime =
      mkPackage
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
      "https://github.com/awakesecurity/purescript-precise-datetime"
      "master"
  , routing-duplex = 
      mkPackage
      [ "typelevel-prelude"
      , "arrays"
      , "globals"
      , "strings"
      , "lazy"
      , "profunctor"
      ]
      "https://github.com/natefaubion/purescript-routing-duplex"
      "master"
  }

in  upstream ⫽ overrides ⫽ additions
