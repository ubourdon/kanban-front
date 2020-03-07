{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
    [ "arrays"
    , "console"
    , "css"
    , "effect"
    , "halogen"
    , "halogen-css"
    , "integers"
    , "lists"
    , "maybe"
    , "newtype"
    , "psci-support"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
