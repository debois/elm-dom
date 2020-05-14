port module Main exposing ( main )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( on, onClick )
import Json.Decode as Decode exposing (Decoder)
import DOM exposing (..)
import Browser


type alias Model = List String

type Msg
  = Log String
  | ClearLog


init : () -> ( Model, Cmd Msg )
init _ =
  ( ["Click on a button!"], Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    Log message ->
      ( message :: model, Cmd.none )
    ClearLog ->
      ( [], Cmd.none )



-- VIEW

-- Utils

elemToString : Decoder String
elemToString =
  let
    concat tName cName = "Tag: " ++ tName ++ ", class: " ++ cName
  in
    Decode.map2 concat tagName className

-- Log

logContainer : List String -> Html Msg
logContainer logs =
  let
    row str = div [] [text str]
  in
    div [ class "log-block" ]
      [ div []
        (List.map row logs)
      , button [ onClick ClearLog ]
        [ text "Clear log" ]
      ]

-- Ancestor Example

ancestorDecode : Decoder String
ancestorDecode =
  ( DOM.target -- Select the event target
    << findAncestor (hasClass "container") -- Find the closest ancestor, with the class container
    <| elemToString
  )
    |> Decode.map (Maybe.withDefault "Ancestor not found")

viewAncestorExample : Html Msg
viewAncestorExample =
  div [ class "example-block" ]
    [ h2 []
      [ text "Find ancestor" ]
    , div [ class "container class-x" ]
        [ div []
          [ Html.map Log <|
              button [ on "click" ancestorDecode ]
                [ text "Click me!" ]
          ]
        ]
    , div [ class "container class-y" ]
        [ div []
          [ Html.map Log <|
              button [ on "click" ancestorDecode ]
                [ text "Click me!" ]
          ]
        ]
    , div [ class "container class-z" ]
        [ div []
          [ Html.map Log <|
              button [ on "click" ancestorDecode ]
                [ text "Click me!" ]
          ]
        ]
    ]

-- Count children example

childrenDecode : Decoder String
childrenDecode =
  ( DOM.target
    << parentElement
    << childNodes
    <| Decode.succeed ()
  )
    |> Decode.map (List.length >> String.fromInt)

countChildrenExample : Html Msg
countChildrenExample =
  div [ class "example-block" ]
    [ h2 []
        [ text "Count children" ]
    , div []
      [ Html.map Log <|
          button [ on "click" childrenDecode ]
            [ text "Click me!" ]
      , Html.map Log <|
          button [ on "click" childrenDecode ]
            [ text "Click me!" ]
      , Html.map Log <|
          button [ on "click" childrenDecode ]
            [ text "Click me!" ]
      ]
    ]

-- Port example

type alias HTMLElement = Decode.Value

-- Get the tag name of the provided element
portDecode : Decoder String
portDecode = tagName

portResultToString : Result Decode.Error String -> String
portResultToString res =
  case res of
    Ok str ->
      "Received tag name: " ++ str
    Err error ->
      "Error: " ++ Decode.errorToString error

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ logContainer model
    , viewAncestorExample
    , countChildrenExample
    ]

-- PORTS

port messageReceiver : (HTMLElement -> msg) -> Sub msg

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  messageReceiver (Decode.decodeValue portDecode >> portResultToString >> Log)

-- STARTAPP


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , subscriptions = subscriptions
    , update = update
    }
