module Data.Environment where 

import Prelude

import Data.URL         (BaseURL(..))

data Environment 
  = Development
  | Production

derive instance eqEnvironment :: Eq Environment
derive instance ordEnvironment :: Ord Environment

type Env =
  { environment :: Environment
  , apiURL      :: BaseURL
  }

toEnvironment :: String -> Environment
toEnvironment = case _ of
  "Production" -> Production
  _            -> Development
