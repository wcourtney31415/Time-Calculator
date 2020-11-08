module Colors exposing (black, blue, green, grey, red)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


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
