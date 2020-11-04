module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { hour1 : String
    , minute1 : String
    , amPm1 : AmPm
    }


init : Model
init =
    { hour1 = ""
    , minute1 = ""
    , amPm1 = Am
    }


type Msg
    = UpdateModel Model


type HourOrMinute
    = Hour
    | Minute


type AmPm
    = Am
    | Pm


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateModel myModel ->
            myModel


timeTextBox model hourOrMinute =
    let
        labels =
            case hourOrMinute of
                Hour ->
                    ( "Hour", "0-12", model.hour1 )

                Minute ->
                    ( "Minute", "0-60", model.minute1 )

        ( label, placeholder, val ) =
            labels
    in
    Input.text
        [ width <| px 100 ]
        { text = val
        , placeholder = Just (Input.placeholder [] (text placeholder))
        , onChange = go model hourOrMinute
        , label = Input.labelAbove [ Font.size 14 ] (text label)
        }


go model hourOrMinute newKey =
    let
        upperBound =
            case hourOrMinute of
                Hour ->
                    12

                Minute ->
                    60

        newModel =
            case hourOrMinute of
                Hour ->
                    { model | hour1 = new }

                Minute ->
                    { model | minute1 = new }

        newKeyAsNum =
            Maybe.withDefault -1 (String.toInt newKey)

        previousVal =
            case hourOrMinute of
                Hour ->
                    model.hour1

                Minute ->
                    model.minute1

        new =
            if newKey == "" then
                "0"

            else if newKeyAsNum == -1 then
                previousVal

            else if newKeyAsNum > -1 && newKeyAsNum < (upperBound + 1) then
                String.fromInt newKeyAsNum

            else
                previousVal
    in
    UpdateModel newModel


timeEntry model =
    Element.row [ spacing 10 ]
        [ timeTextBox model Hour
        , timeTextBox model Minute
        , Input.button
            [ alignBottom
            , height <| px 20
            , Border.rounded 10
            , Background.color <| rgb 0.8 0.8 0.8
            , padding 20
            ]
            { onPress =
                Maybe.Just <|
                    UpdateModel
                        { model
                            | amPm1 =
                                if model.amPm1 == Am then
                                    Pm

                                else
                                    Am
                        }
            , label =
                Element.el [] <|
                    text <|
                        if model.amPm1 == Am then
                            "AM"

                        else
                            "PM"
            }
        ]


view model =
    let
        red =
            rgb 1 0 0
    in
    Element.layout
        [ padding 25 ]
    <|
        Element.column
            [ width fill
            , height fill
            , spacing 30
            ]
            [ timeEntry model
            , timeEntry model
            ]
