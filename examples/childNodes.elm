module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Platform.Cmd exposing (none)
import Platform.Sub
import Json.Decode as Decode exposing (Decoder)
import String
import DOM exposing (..)
import Browser


type alias Model =
  String


model0 : Model
model0 =
  "(Nothing)"


type Msg
  = Measure String


init : () -> ( Model, Cmd Msg )
init _ =
  ( "", none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Measure str ->
      ( str, none )


items : Html a
items =
  List.range 0 5
    |> List.map
      (\idx ->
        li
          -- elm-dom will later extract the class names directly from the DOM out of
          -- the elements.
          [ class <| "class-" ++ (String.fromInt idx) ]
          [ text <| "Item " ++ String.fromInt idx ]
      )
    -- childNodes
    |>
      ul []



--childNode 0 (b)


decode : Decoder String
decode =
  (DOM.target
    <| parentElement
    <| childNode 0
    -- (a)
    <|
      childNode 0
    -- (b)
    <|
      childNodes className)
    -- Extract the class name from the elements
    |>
      Decode.map (String.join ", ")


view : Model -> Html Msg
view model_ =
  div
    -- parentElement
    [ class "root" ]
    [ div
      -- childNode 0 (a)
      [ class "container" ]
      [ items ]
      -- See childNode 0 (b) in the above "items" function
    , div
      [ class "value" ]
      [ text <| "Model value: " ++ modelToString model_ ]
    , Html.map Measure <|
      button
        -- target
        [ class "button"
        , on "click" decode
        ]
        [ text "Click" ]
    ]

modelToString _ = ""

main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = always Sub.none
    , view = view
    }
