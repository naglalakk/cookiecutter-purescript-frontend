module Store where

import Prelude
import Data.Maybe (Maybe(..))
import Data.URL (BaseURL)
import Routing.PushState (PushStateInterface)
import Data.User(User)

data Environment
  = Development 
  | Staging
  | Production

derive instance eqEnvironment :: Eq Environment
derive instance ordEnvironment :: Ord Environment

toEnvironment :: String -> Environment
toEnvironment "Production"  = Production
toEnvironment "Staging"     = Staging
toEnvironment _             = Development

type Store =
  { baseUrl :: BaseURL 
  , environment :: Environment
  , pushInterface :: PushStateInterface
  , currentUser :: Maybe User
  }

data Action
  = Idle
  | LoginUser User
  | LogoutUser

reduce :: Store -> Action -> Store
reduce store = case _ of
  Idle -> store

  LoginUser user ->
    store { currentUser = Just user }

  LogoutUser ->
    store { currentUser = Nothing }

