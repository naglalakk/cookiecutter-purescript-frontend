module Form.Validation where

import Prelude

import Data.Either              (Either(..))
import Data.Formatter.DateTime  (unformat)
import Data.PreciseDateTime     (fromDateTime)
import Data.String              (null)
import Timestamp                (Timestamp(..)
                                ,dateTimeShortFormatter)
import Formless                 as F

import Data.Auth                (Password(..))
import Data.User                (Username(..))
import Form.Error               (FormError(..))


validateUsername :: forall form m. Monad m
                 => F.Validation form m FormError String Username
validateUsername = F.hoistFnE_ \str -> 
  if null str
    then Left Required
    else Right $ Username str

validatePassword :: forall form m. Monad m
                 => F.Validation form m FormError String Password
validatePassword = F.hoistFnE_ \str -> 
  if null str
    then Left Required
    else Right $ Password str

validateStr :: forall form m. Monad m
            => F.Validation form m FormError String String
validateStr = F.hoistFnE_ \str ->
  if null str
    then Left Required
    else Right str

-- | Validates a DateTime string
-- returns a Timestamp on success
validateDateTime  :: forall form m. Monad m
                  => F.Validation form m FormError String Timestamp
validateDateTime = F.hoistFnE_ \str ->
  let
    dt = unformat dateTimeShortFormatter str
  in
    case dt of
      Left  err -> Left  $ InvalidDateTime err
      Right ts  -> Right $ Timestamp $ fromDateTime ts
