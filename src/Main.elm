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


red =
    rgb 1 0 0


blue =
    rgb 0 0 1


green =
    rgb 0 1 0


black =
    rgb 0 0 0


grey x =
    rgb x x x


findWith col =
    Background.color col


type alias Model =
    { time1 : Time
    }


type alias Time =
    { hour : String
    , minute : String
    , amPm : AmPm
    }


init : Model
init =
    { time1 =
        { hour = ""
        , minute = ""
        , amPm = Am
        }
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


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateModel myModel ->
            myModel

        UpdateTime newTime ->
            { model | time1 = newTime }


timeTextBox time hourOrMinute =
    let
        labels =
            case hourOrMinute of
                Hour ->
                    ( "Hour", "1-12", time.hour )

                Minute ->
                    ( "Minute", "0-60", time.minute )

        ( label, placeholder, val ) =
            labels
    in
    Input.text
        [ width <| px 100 ]
        { text = val
        , placeholder = Just (Input.placeholder [ Background.color <| grey 0.05 ] (text placeholder))
        , onChange = updateTime time hourOrMinute
        , label =
            Input.labelAbove
                [ Font.size 14
                , Font.bold
                ]
                (text label)
        }


updateTime : Time -> HourOrMinute -> String -> Msg
updateTime model hourOrMinute newKey =
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
                    { model | hour = new }

                Minute ->
                    { model | minute = new }

        newKeyAsNum =
            Maybe.withDefault -1 (String.toInt newKey)

        previousVal =
            case hourOrMinute of
                Hour ->
                    model.hour

                Minute ->
                    model.minute

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
    UpdateTime newModel


timeEntry model =
    let
        myTime =
            model.time1
    in
    Element.row
        [ spacing 10
        , padding 20
        , Border.rounded 10

        -- , Border.innerGlow red 4
        , Background.color <| rgb 0.3 0.3 0.3
        ]
        [ timeTextBox model.time1 Hour
        , timeTextBox model.time1 Minute
        , Input.button
            [ alignBottom
            , height <| px 20
            , Border.rounded 10
            , Background.color <| rgb 0.8 0.8 0.8
            , padding 20
            ]
            { onPress =
                let
                    modification =
                        { myTime
                            | amPm = iif ( myTime.amPm == Am, Pm, Am )
                        }
                in
                Maybe.Just <|
                    UpdateModel
                        { model
                            | time1 = modification
                        }
            , label =
                Element.el
                    [ width fill
                    , height fill
                    , moveUp 10

                    -- , padding 50
                    ]
                <|
                    text <|
                        iif ( model.time1.amPm == Am, "AM", "PM" )
            }
        ]


iif ( eval, isTrue, isFalse ) =
    if eval then
        isTrue

    else
        isFalse


view model =
    Element.layout
        [ padding 25 ]
    <|
        Element.column
            [ width fill
            , height fill
            ]
            [ Element.column
                [ spacing 20
                , Background.color <| rgb 0.1 0.1 0.1
                , Border.rounded 10
                , Border.shadow
                    { offset = ( 5, 5 )
                    , size = 2
                    , blur = 4
                    , color = black
                    }
                , padding 20
                ]
                [ timeEntry model
                , timeEntry model
                ]
            ]
