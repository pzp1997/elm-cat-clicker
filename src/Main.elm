module Main exposing (..)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import SharedStyles exposing (..)


{ id, class, classList } =
    homepageNamespace


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
            [ (Cat "Tom"
                ("https://upload.wikimedia.org/wikipedia/commons/"
                    ++ "thumb/a/a6/Tiggy_the_talking_cat.JPG/"
                    ++ "1024px-Tiggy_the_talking_cat.JPG"
                )
                0
              )
            , (Cat "Captain McFurry"
                ("https://newevolutiondesigns.com/images/freebies/"
                    ++ "cat-wallpaper-preview-24.jpg"
                )
                0
              )
            , (Cat "Snowball"
                ("http://mypetforumonline.com/wp-content/"
                    ++ "uploads/2014/08/fat-cat.jpg"
                )
                0
              )
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

                            updatedAllCats =
                                Array.set
                                    model.currCatIndex
                                    updatedCat
                                    model.allCats
                        in
                            ( { model | allCats = updatedAllCats }, Cmd.none )

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
        [ h1 [ class [ TextCenter ] ] [ text "Click the cat!" ]
        , catListView model.allCats
        , catView (Array.get model.currCatIndex model.allCats)
        ]


catListView : Array Cat -> Html Msg
catListView cats =
    Array.indexedMap
        (\idx cat ->
            li
                [ class [ CatsListItem ], onClick (SwitchCat idx) ]
                [ text cat.name ]
        )
        cats
        |> Array.toList
        |> ul [ id CatsList ]


catView : Maybe Cat -> Html Msg
catView currCat =
    case currCat of
        Nothing ->
            div [] []

        Just cat ->
            div [ class [ TextCenter ] ]
                [ h2 [] [ text cat.name ]
                , img
                    [ class [ CatImg ]
                    , src cat.imgSrc
                    , alt ("Picture of " ++ cat.name)
                    , onClick ClickCat
                    ]
                    []
                , h2 [] [ text <| toString cat.clicks ]
                ]
