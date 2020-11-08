module UsefulFunctions exposing (iif)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


iif ( eval, isTrue, isFalse ) =
    if eval then
        isTrue

    else
        isFalse


findWith col =
    Background.color col
