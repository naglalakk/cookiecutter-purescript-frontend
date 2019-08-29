{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "{{ cookiecutter.project_name }}"
, dependencies =
    [ "affjax" 
    , "argonaut" 
    , "css"
    , "console" 
    , "datetime" 
    , "dotenv"
    , "effect"
    , "express" 
    , "halogen" 
    , "halogen-formless" 
    , "psci-support"
    , "routing"
    , "routing-duplex" 
    , "strings" 
    ]
, packages =
    ./packages.dhall
}
