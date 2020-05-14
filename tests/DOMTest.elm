module DOMTest exposing (tests)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Json.Decode as Decode exposing (Decoder)
import DOM



tests : Test
tests =
  describe "DOM module"
    [ predicatesTest
    ]

-- TRAVERSING

-- GEOMETRY

-- PREDICATES

predicatesTest : Test
predicatesTest =
  describe "Predicates"
    [ test "hasClass" <|
      \_ ->
        let
          res = Decode.decodeString (DOM.hasClass "test-class-1") hasClassJson
        in
          Expect.equal res (Ok True)
    , test "hasClass False" <|
      \_ ->
        let
          res = Decode.decodeString (DOM.hasClass "test-class-3") hasClassJson
        in
          Expect.equal res (Ok False)
    , test "isTag" <|
      \_ ->
        let
          res = Decode.decodeString (DOM.isTag "DIV") isTagJson
        in
          Expect.equal res (Ok True)
    , test "isTag False" <|
      \_ ->
        let
          res = Decode.decodeString (DOM.isTag "SPAN") isTagJson
        in
          Expect.equal res (Ok False)
    , test "negate" <|
      \_ ->
        let
          res = Decode.decodeString (DOM.negate <| DOM.isTag "SPAN") isTagJson
        in
          Expect.equal res (Ok True)
    , test "and" <|
      \_ ->
        let
          pred = DOM.and (DOM.isTag "DIV") (DOM.isTag "SPAN")
          res = Decode.decodeString pred isTagJson
        in
          Expect.equal res (Ok False)
    , test "or" <|
      \_ ->
        let
          pred = DOM.or (DOM.isTag "DIV") (DOM.isTag "SPAN")
          res = Decode.decodeString pred isTagJson
        in
          Expect.equal res (Ok True)
    ]


hasClassJson : String
hasClassJson = """
{
  "classList":{"0":"test-class-1", "1":"test-class-2", "values":"test-class-1 test-class-2"},
  "className":"test-class-1 test-class-2"
}
"""

isTagJson : String
isTagJson = """
{
  "tagName":"DIV"
}
"""

-- MISC
