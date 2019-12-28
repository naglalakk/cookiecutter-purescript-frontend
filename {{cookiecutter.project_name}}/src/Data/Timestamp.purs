module Data.Timestamp where

import Prelude
import Data.Either              (Either, note, fromRight)
import Data.Argonaut.Decode     (class DecodeJson
                                ,decodeJson)
import Data.Argonaut.Encode     (class EncodeJson, encodeJson)
import Data.DateTime            as DT
import Data.List                (List(..), fromFoldable)
import Data.Newtype             (class Newtype, unwrap)
import Data.PreciseDateTime     as PDT
import Data.RFC3339String       (RFC3339String(..))
import Data.Formatter.DateTime  (Formatter
                                ,FormatterCommand(..)
                                ,format)
import Effect                   (Effect)
import Effect.Now               (nowDateTime)
import Formless                 as F
import Partial.Unsafe           (unsafePartial)

newtype Timestamp = Timestamp PDT.PreciseDateTime

derive instance newtypeTimestamp :: Newtype Timestamp _
derive instance eqTimestamp :: Eq Timestamp
derive instance ordTimestamp :: Ord Timestamp

instance showTimestamp :: Show Timestamp where
  show (Timestamp pdt) = show pdt

instance decodeJsonTimestamp :: DecodeJson Timestamp where
  decodeJson = fromString <=< decodeJson

instance encodeJsonTimestamp :: EncodeJson Timestamp where
  encodeJson (Timestamp pdt) = encodeJson $ formatToDateTimeStr $ Timestamp pdt

instance initialTimestamp :: F.Initial Timestamp where
  initial = defaultTimestamp

-- | Try to parse a `PreciseDateTime` from a string.
fromString :: String -> Either String Timestamp
fromString = 
  map Timestamp
    <<< note "Could not parse RFC339 string" 
    <<< PDT.fromRFC3339String 
    <<< RFC3339String

defaultTimestamp :: Timestamp
defaultTimestamp 
  = unsafePartial $ 
    fromRight $ 
    fromString 
    "2019-07-01T00:00:00"

nowTimestamp :: Effect Timestamp
nowTimestamp = do
  now <- nowDateTime
  pure $ Timestamp $ PDT.fromDateTime now

dateFormatter :: Formatter
dateFormatter 
  = fromFoldable 
    [ DayOfMonthTwoDigits
    , Placeholder "."
    , MonthTwoDigits
    , Placeholder "."
    , YearTwoDigits
    ]

-- Todo: There must be
-- a more straight forward way
-- to simply turn precisedatetimething
-- to ISO string?
dateTimeFormatter :: Formatter
dateTimeFormatter
  = fromFoldable
    [ YearFull
    , Placeholder "-"
    , MonthTwoDigits
    , Placeholder "-"
    , DayOfMonthTwoDigits
    , Placeholder "T"
    , Hours24
    , Placeholder ":"
    , MinutesTwoDigits
    , Placeholder ":"
    , SecondsTwoDigits
    , Placeholder "."
    , Milliseconds
    , Placeholder "Z"
    ]

-- Human readable dateTimeFormatter
-- This is what is displayed to the user
-- when editing DateTime
-- d.m.YYYY HH:MM:SS
dateTimeShortFormatter :: Formatter
dateTimeShortFormatter 
  = fromFoldable
    [ DayOfMonthTwoDigits
    , Placeholder "."
    , MonthTwoDigits
    , Placeholder "."
    , YearFull
    , Placeholder " "
    , Hours24
    , Placeholder ":"
    , MinutesTwoDigits
    , Placeholder ":"
    , SecondsTwoDigits 
    ]

formatToDateStr :: Timestamp -> String
formatToDateStr (Timestamp (PDT.PreciseDateTime dt nan))
  = format dateFormatter dt

formatToDateTimeShortStr :: Timestamp -> String
formatToDateTimeShortStr (Timestamp (PDT.PreciseDateTime dt nan))
  = format dateTimeShortFormatter dt

formatToDateTimeStr :: Timestamp -> String
formatToDateTimeStr (Timestamp (PDT.PreciseDateTime dt nan))
  = format dateTimeFormatter dt

