module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, classList)
import Html.Events exposing (onClick)

main : Program Never Model Msg
main =
    Html.program
        { init = (initModel, initCmd)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

type alias Model = List String

type Msg = Incoming String

initModel = []

initCmd = Cmd.none

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "jumbotron" ]
              [ h1 [] [ text "Web Sockets Test" ]
              , button [ onClick (Incoming "hello!") ] [text "Hit me!"]
              ]
        , div [ id "messages" ] (List.map (\s -> p [] [text s]) model)
        ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Incoming s ->
            (s :: model, Cmd.none)
