module MessagesModels exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


type alias Model =
    { time1 : Time
    }


type Msg
    = UpdateModel Model
    | UpdateTime Time


type HourOrMinute
    = Hour
    | Minute


type AmPm
    = Am
    | Pm


type alias Time =
    { hour : String
    , minute : String
    , amPm : AmPm
    }
