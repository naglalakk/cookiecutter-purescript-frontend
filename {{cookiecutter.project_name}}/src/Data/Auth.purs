module Data.Auth where

{% if cookiecutter.user == "y" %}
import Prelude
import Data.Argonaut.Encode     (class EncodeJson)
import Data.Binary.Base64       as B64
import Data.Generic.Rep         (class Generic)
import Data.Maybe               (Maybe)
import Data.Newtype             (class Newtype, unwrap)
import Data.TextEncoder         (encodeUtf8)
import Effect                   (Effect)
import Web.HTML                 (window)
import Web.HTML.Window          (localStorage)
import Web.Storage.Storage      (getItem
                                ,removeItem
                                ,setItem)

import Config                   (apiKey)
import Data.User                (Username) {% endif %}
{% if cookiecutter.user == "y" %}
newtype Password = Password String

derive instance newtypePassword :: Newtype Password _
derive instance genericPassword :: Generic Password _
derive instance eqPassword :: Eq Password

derive newtype instance encodeJsonPassword :: EncodeJson Password
{% endif %}
data APIAuth
  = Basic String
  | Token String

{% if cookiecutter.user == "y" %}
-- Default API Auth credentials
apiAuth :: APIAuth 
apiAuth = Basic apiKey
newtype UserAuth = UserAuth
  { username :: Username
  , password :: Password
  }

derive instance newtypeAuth :: Newtype UserAuth _
derive instance genericAuth :: Generic UserAuth _
derive instance eqAuth      :: Eq UserAuth

derive newtype instance encodeJsonAuth :: EncodeJson UserAuth

base64encode :: String -> String -> String
base64encode username password = 
  B64.encode $ encodeUtf8 
             $ username 
             <> sep 
             <> password
  where
    sep      = ":"

base64encodeUserAuth :: UserAuth -> String
base64encodeUserAuth (UserAuth auth) = 
  base64encode (unwrap auth.username) (unwrap auth.password)

-- | Helper functions for auth token stored in localStorage
tokenKey = "token" :: String

readToken :: Effect (Maybe String)
readToken = 
  getItem tokenKey =<< localStorage =<< window

writeToken :: String -> Effect Unit
writeToken str =
  setItem tokenKey str =<< localStorage =<< window

removeToken :: Effect Unit
removeToken =
  removeItem tokenKey =<< localStorage =<< window
{% endif %}
