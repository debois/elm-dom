module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Platform.Cmd exposing (none)
import Platform.Sub
import Json.Decode as Decode exposing (Decoder)
import DOM exposing (..)
import Browser


type alias Model = String

type Msg
  = Display String


init : () -> ( Model, Cmd Msg )
init _ =
  ( "Click on a button!", none )


update : Msg -> Model -> ( Model, Cmd Msg )
update action _ =
  case action of
    Display str ->
      ( str, none )



-- VIEW

decode : Decoder String
decode =
  ( DOM.target
    <| findAncestor (hasClass "container")
    <| elemToString
  )
    |> Decode.map (Maybe.withDefault "Ancestor not found")

elemToString : Decoder String
elemToString =
  let
    concat tName cName = "Tag: " ++ tName ++ ", class: " ++ cName
  in
    Decode.map2 concat tagName className

view : Model -> Html Msg
view model =
  div []
    [ p []
        [ text model ]
    , div [ class "container class-x" ]
        [ div []
          [ Html.map Display <|
              button [ on "click" decode ]
                [ text "Click me!" ]
          ]
        ]
    , div [ class "container class-y" ]
        [ div []
          [ Html.map Display <|
              button [ on "click" decode ]
                [ text "Click me!" ]
          ]
        ]
    , div [ class "container class-z" ]
        [ div []
          [ Html.map Display <|
              button [ on "click" decode ]
                [ text "Click me!" ]
          ]
        ]
    ]


-- STARTAPP


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , subscriptions = always Sub.none
    , update = update
    }
