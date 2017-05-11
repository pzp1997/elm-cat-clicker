module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Cat =
    { name : String
    , imgSrc : String
    , clicks : Int
    }


type alias Model =
    { allCats : Array Cat
    , currCatIndex : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        (Array.fromList
            [ (Cat "Tom" "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Tiggy_the_talking_cat.JPG/1024px-Tiggy_the_talking_cat.JPG" 0)
            , (Cat "Captain McFurry" "https://newevolutiondesigns.com/images/freebies/cat-wallpaper-preview-24.jpg" 0)
            , (Cat "Snowball" "http://mypetforumonline.com/wp-content/uploads/2014/08/fat-cat.jpg" 0)
            ]
        )
        0
    , Cmd.none
    )



-- UPDATE


type Msg
    = ClickCat
    | SwitchCat Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickCat ->
            let
                currCat =
                    Array.get model.currCatIndex model.allCats
            in
                case currCat of
                    Nothing ->
                        ( model, Cmd.none )

                    Just cat ->
                        let
                            updatedCat =
                                { cat | clicks = cat.clicks + 1 }
                        in
                            ( { model | allCats = (Array.set model.currCatIndex updatedCat model.allCats) }
                            , Cmd.none
                            )

        SwitchCat newIndex ->
            ( { model | currCatIndex = newIndex }, Cmd.none )



-- SUBSCRIBPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ catList model.allCats
        , cat (Array.get model.currCatIndex model.allCats)
        ]


catList : Array Cat -> Html Msg
catList cats =
    ul [] (Array.toList (Array.indexedMap (\i cat -> li [ onClick (SwitchCat i) ] [ text cat.name ]) cats))


cat : Maybe Cat -> Html Msg
cat currCat =
    case currCat of
        Nothing ->
            div [] []

        Just c ->
            div []
                [ h2 [] [ text c.name ]
                , img [ src c.imgSrc, onClick ClickCat ] []
                , p [] [ text <| toString <| c.clicks ]
                ]
