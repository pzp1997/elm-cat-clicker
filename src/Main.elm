module Main exposing (..)

import Array exposing (Array)
import Array.Extra
import Html exposing (Html, div, h1, h2, ul, li, img, text)
import Html.Attributes exposing (src, alt)
import Html.Events exposing (onClick)
import SharedStyles exposing (homepageNamespace, CssClasses(..), CssIds(..))


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
    { cats : Array Cat
    , currIndex : Int
    }


catData : List Cat
catData =
    [ Cat "Tom"
        ("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/"
            ++ "Tiggy_the_talking_cat.JPG/1024px-Tiggy_the_talking_cat.JPG"
        )
        0
    , Cat "Captain McFurry"
        ("https://newevolutiondesigns.com/images/freebies/"
            ++ "cat-wallpaper-preview-24.jpg"
        )
        0
    , Cat "Snowball"
        "http://mypetforumonline.com/wp-content/uploads/2014/08/fat-cat.jpg"
        0
    ]


init : ( Model, Cmd Msg )
init =
    ( Model (Array.fromList catData) 0, Cmd.none )



-- UPDATE


type Msg
    = ClickCat
    | SwitchCat Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickCat ->
            let
                updatedCats =
                    Array.Extra.update model.currIndex incrClicks model.cats
            in
                ( { model | cats = updatedCats }, Cmd.none )

        SwitchCat newIndex ->
            ( { model | currIndex = newIndex }, Cmd.none )


incrClicks : Cat -> Cat
incrClicks cat =
    { cat | clicks = cat.clicks + 1 }



-- SUBSCRIBPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [ class [ TextCenter ] ] [ text "Click the cat!" ]
        , catListView model.cats
        , case Array.get model.currIndex model.cats of
            Nothing ->
                text ""

            Just cat ->
                catView cat
        ]


catListView : Array Cat -> Html Msg
catListView cats =
    Array.indexedMap catListItemView cats |> Array.toList |> ul [ id CatsList ]


catListItemView : Int -> Cat -> Html Msg
catListItemView index cat =
    li [ class [ CatsListItem ], onClick (SwitchCat index) ] [ text cat.name ]


catView : Cat -> Html Msg
catView cat =
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
