{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "{{ cookiecutter.project_name }}"
, dependencies =
    [ "affjax" {% if cookiecutter.user == "y" %}
    , "aff-bus" {% endif %}
    , "argonaut" {% if cookiecutter.user == "y" %}
    , "b64" {% endif %}
    , "css"
    , "console" 
    , "datetime" 
    , "dotenv"
    , "effect"
    , "encoding"
    , "express" 
    , "formatters"
    , "halogen" 
    , "halogen-formless" 
    , "precise-datetime"
    , "psci-support"
    , "routing"
    , "routing-duplex" 
    , "simple-json"
    , "strings" 
    , "spec"
    , "timestamp"
    ]
, packages =
    ./packages.dhall
}
