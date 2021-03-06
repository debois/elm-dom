module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Platform.Cmd exposing (none)
import Platform.Sub
import String
import Json.Decode as Json exposing (Decoder)
import DOM exposing (..)
import Browser


type alias Model =
  () -> List Float


model : Model
model =
  always []


type Msg
  = Measure Json.Value
  | NoOp


init : () -> ( Model, Cmd Msg )
init _ =
  ( always [], none )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model_ =
  case action of
    Measure val ->
      ( (\_ ->
        Json.decodeValue decode val
          |> Result.toMaybe
          |> Maybe.withDefault []
        )
      , none
      )

    NoOp ->
      ( model, none )



-- VIEW



decode : Decoder (List Float)
decode =
  DOM.target
    -- (a)
    <|
      parentElement
    -- (b)
    <|
      childNode 0
    -- (c)
    <|
      childNode 0
    -- (d)
    <|
      childNodes
        -- (e)
        DOM.offsetHeight



-- read the width of each element


css : Attribute a
css =
  style "padding" "1em"


view : Model -> Html Msg
view model_ =
  div
    -- parentElement (b)
    []
    [ div
      -- childNode 0 (c)
      [ css ]
      [ div
        -- childNode 0 (d)
        []
        [ span [ css ] [ text "short" ]
        , span [ css ] [ text "somewhat long" ]
        , span [ css ] [ text "longer than the others" ]
        , span [ css ] [ text "much longer than the others" ]
        ]
        -- childNodes (e)
      ]
    , Html.map Measure <|
      button
        -- target (a)
        [ css
        , on "click" Json.value
        ]
        [ text "Measure!" ]
    , button
      [ css
      , onClick NoOp
      ]
      [ text "Call the function."
      ]
    , div
      [ css ]
      [ model_ ()
        |> List.map modelToString
        |> String.join ", "
        |> text
      , text "!"
      ]
    ]

modelToString _ =
    ""


-- APP


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , subscriptions = always Sub.none
    , update = update
    , view = view
    }
