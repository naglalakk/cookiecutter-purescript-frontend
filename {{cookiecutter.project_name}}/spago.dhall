{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "competitionfeed-newsletter-component"
, dependencies =
    [ "effect"
    , "console" 
    , "halogen" 
    , "express" 
    , "halogen-formless" 
    , "strings" 
    , "datetime" 
    , "routing"
    , "routing-duplex" 
    , "argonaut" 
    , "affjax" ]
, packages =
    ./packages.dhall
}
