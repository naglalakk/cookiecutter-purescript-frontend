module Data.Environment where 

import Prelude {% if cookiecutter.user == "y" %}
import Data.Maybe           (Maybe)
import Effect.Aff.Bus       (BusRW)
import Effect.Ref           (Ref) {% endif %}
import Routing.PushState    (PushStateInterface)

import Data.URL             (BaseURL) {% if cookiecutter.user == "y" %}
import Data.User            (User) {% endif %}

data Environment 
  = Development
  | Staging
  | Production

derive instance eqEnvironment :: Eq Environment
derive instance ordEnvironment :: Ord Environment

type Env =
  { environment :: Environment
  , apiURL      :: BaseURL {% if cookiecutter.user == "y" %}
  , userEnv     :: UserEnv {% endif %}
  , pushInterface :: PushStateInterface
  }
{% if cookiecutter.user == "y" %}
type UserEnv =
  { currentUser :: Ref (Maybe User)
  , userBus     :: BusRW (Maybe User)
  } {% endif %}

toEnvironment :: String -> Environment
toEnvironment "Production"  = Production
toEnvironment "Staging"     = Staging
toEnvironment _             = Development
