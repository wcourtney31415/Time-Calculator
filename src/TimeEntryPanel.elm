module TimeEntryPanel exposing (..)

import Browser
import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import MessagesModels exposing (..)
import UsefulFunctions exposing (..)


timeEntryPanel model =
    Element.column
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
        , Background.color <| grey 0.3
        ]
        [ hourTextBox model.time1
        , minuteTextBox model.time1
        , Input.button
            [ alignBottom
            , height <| px 20
            , Border.rounded 10
            , Background.color <| grey 0.8
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


hourTextBox time =
    let
        labels =
            ( "Hour", "1-12", time.hour )

        ( label, placeholder, val ) =
            labels
    in
    Input.text
        [ width <| px 100
        , Border.rounded 5
        ]
        { text = val
        , placeholder =
            Just
                (Input.placeholder
                    [ Background.color <| grey 0.05
                    , Border.rounded 5
                    ]
                    (text placeholder)
                )
        , onChange = updateTime time Hour
        , label =
            Input.labelAbove
                [ Font.size 14
                , Font.bold
                ]
                (text label)
        }


minuteTextBox time =
    let
        labels =
            ( "Minute", "0-60", time.minute )

        ( label, placeholder, val ) =
            labels
    in
    Input.text
        [ width <| px 100
        , Border.rounded 5
        ]
        { text = val
        , placeholder =
            Just
                (Input.placeholder
                    [ Background.color <| grey 0.05
                    , Border.rounded 5
                    ]
                    (text placeholder)
                )
        , onChange = updateTime time Minute
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
