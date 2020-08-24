module Data.User where

import Prelude
import Data.Argonaut            (decodeJson
                                ,(~>),(:=)
                                ,(.:), (.:?))
import Data.Argonaut.Encode     (class EncodeJson)
import Data.Argonaut.Decode     (class DecodeJson)
import Data.Generic.Rep         (class Generic)
import Data.Generic.Rep.Show    (genericShow)
import Data.Maybe               (Maybe)
import Data.Newtype             (class Newtype)
import Formless                 as F
import Timestamp                (Timestamp)

import Data.Email               (Email)

newtype UserId = UserId Int

derive instance newtypeUserId :: Newtype UserId _
derive instance genericUserId :: Generic UserId _
derive instance eqUserId :: Eq UserId
derive instance ordUserId :: Ord UserId

derive newtype instance encodeJsonUserId :: EncodeJson UserId
derive newtype instance decodeJsonUserId :: DecodeJson UserId

instance showUserId :: Show UserId where
  show = genericShow

instance initialUserId :: F.Initial UserId where
  initial = UserId 0

newtype Username = Username String

derive instance newtypeUsername :: Newtype Username _
derive instance genericUsername :: Generic Username _
derive instance eqUsername :: Eq Username
derive instance ordUsername :: Ord Username

derive newtype instance encodeJsonUsername :: EncodeJson Username
derive newtype instance decodeJsonUsername :: DecodeJson Username

instance showUsername :: Show Username where
  show = genericShow

-- | User type. 
--   We do not keep the password
--   within this data structure for safety
--   reasons.
newtype User = User 
  { id       :: UserId
  , username :: Username
  , email    :: Maybe Email
  , isAdmin  :: Boolean
  , createdAt :: Timestamp
  , updatedAt :: Maybe Timestamp
  }

derive instance newtypeUser :: Newtype User _
derive instance genericUser :: Generic User _
derive instance eqUser :: Eq User
derive instance ordUser :: Ord User

instance encodeJsonUser :: EncodeJson User where
  encodeJson (User user)
    =  "username"    := user.username
    ~> "email"      := user.email
    ~> "is_admin"   := user.isAdmin
    ~> "created_at" := user.createdAt
    ~> "updated_at" := user.updatedAt

instance decodeJsonUser :: DecodeJson User where
  decodeJson json = do
    obj <- decodeJson json
    id <- obj .: "id"
    let 
      userId = UserId id
    username <- obj .: "username"
    email    <- obj .:? "email"
    isAdmin  <- obj .: "is_admin"
    createdAt <- obj .: "created_at"
    updatedAt <- obj .:? "updated_at"
    pure $ User 
      { id: userId
      , username: username
      , email: email
      , isAdmin: isAdmin
      , createdAt: createdAt
      , updatedAt: updatedAt
      }

instance showUser :: Show User where
  show = genericShow
