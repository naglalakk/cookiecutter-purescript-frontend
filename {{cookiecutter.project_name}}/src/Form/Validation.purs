module Form.Validation where

import Data.Either (Either(..))
import Data.String (null)

data FormError
  = Required -- Field input is required
  | Invalid -- Field input is invalid

validateRequiredStr :: String -> Either FormError String
validateRequiredStr str =
  if null str then
    Left Required
  else
    Right str

errorToStr :: FormError -> String
errorToStr = case _ of
  Required -> "Field is required"
  Invalid -> "Field is invalid"
