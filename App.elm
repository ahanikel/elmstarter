module App exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (id, class, classList, placeholder)
import Html.Events     exposing (onClick, onInput)
import WebSocket

main : Program Never Model Msg
main =
    Html.program
        { init = (initModel, initCmd)
        , view = view
        , update = update
        , subscriptions = websocketSubscription
        }

type alias Model = { textToSend : String
                   , textReceived : List String
                   }

type Msg = Incoming String
         | SendText String
         | SendNow

initModel = Model "" []

initCmd = Cmd.none

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "jumbotron" ]
              [ h1 [] [ text "Web Sockets Test" ]
              ]
        , input [ onInput SendText, placeholder "Send some text" ] []
        , button [ onClick SendNow ] [ text "Send now!" ]
        , div [ id "messages" ] (List.map (\s -> p [] [text s]) model.textReceived)
        ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Incoming s ->
            ( { model | textReceived = s :: model.textReceived }, Cmd.none )
        SendText s ->
            ( { model | textToSend = s }, Cmd.none )
        SendNow ->
            ( { model | textToSend = "" }
            , WebSocket.send "ws://echo.websocket.org" model.textToSend
            )

websocketSubscription : Model -> Sub Msg
websocketSubscription model = WebSocket.listen "ws://echo.websocket.org" Incoming
