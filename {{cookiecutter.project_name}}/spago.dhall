{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "{{ cookiecutter.project_name }}"
, dependencies =
    [ "effect"
    , "console" 
    , "halogen" 
    , "express" ]
, packages =
    ./packages.dhall
}
