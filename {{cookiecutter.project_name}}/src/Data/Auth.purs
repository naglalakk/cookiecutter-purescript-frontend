module Data.Auth where

import Prelude
import Config (username, userPass, apiToken)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Binary.Base64 as B64
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype, unwrap)
import Data.String (null)
import Data.TextEncoder (encodeUtf8)
import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (getItem, removeItem, setItem)

data APIAuth
  = Basic String
  | Bearer String

-- Default API Auth credentials
apiAuth :: APIAuth
apiAuth = case null apiToken of
  true -> Basic $ base64encode username userPass
  false -> Bearer apiToken

newtype UserAuth = UserAuth
  { username :: String
  , password :: String
  }

derive instance newtypeAuth :: Newtype UserAuth _
derive instance genericAuth :: Generic UserAuth _
derive instance eqAuth :: Eq UserAuth

derive newtype instance encodeJsonAuth :: EncodeJson UserAuth

base64encode :: String -> String -> String
base64encode username password =
  B64.encode
    $ encodeUtf8
    $ username
        <> ":"
        <> password

base64encodeUserAuth :: UserAuth -> String
base64encodeUserAuth (UserAuth auth) =
  base64encode auth.username auth.password

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
