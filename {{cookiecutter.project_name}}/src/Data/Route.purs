module Data.Route where

import Prelude hiding                   ((/))
import Data.Generic.Rep                 (class Generic)
import Data.Generic.Rep.Show            (genericShow)
import Routing.Duplex                   (RouteDuplex', root)
import Routing.Duplex.Generic           (noArgs, sum)
import Routing.Duplex.Generic.Syntax    ((/))

data Route
  = Home {% if cookiecutter.user == "y" %}
  | Login {% endif %}

derive instance genericRoute :: Generic Route _
derive instance eqRoute :: Eq Route
derive instance ordRoute :: Ord Route

instance showRoute :: Show Route where
  show = genericShow

routeCodec :: RouteDuplex' Route
routeCodec = sum
  { "Home": noArgs {% if cookiecutter.user == "y" %}
  , "Login" : "login" / noArgs {% endif %}
  }
