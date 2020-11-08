module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import MessagesModels exposing (..)
import TimeEntryPanel exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    { time1 =
        { hour = ""
        , minute = ""
        , amPm = Am
        }
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateModel myModel ->
            myModel

        UpdateTime newTime ->
            { model | time1 = newTime }


view model =
    Element.layout
        [ padding 25 ]
    <|
        Element.column
            [ width fill
            , height fill
            ]
            [ timeEntryPanel model
            ]
