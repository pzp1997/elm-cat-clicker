module Main exposing (..)

import Html exposing (Html, div, h1, h2, ul, li, img, text)
import Html.Attributes exposing (src, alt)
import Html.Events exposing (onClick)
import List.Selection exposing (Selection)
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
    Selection Cat


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
    ( List.Selection.fromList catData, Cmd.none )



-- UPDATE


type Msg
    = ClickCat
    | SwitchCat Cat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickCat ->
            ( updateSelected incrementClicks model, Cmd.none )

        SwitchCat newCat ->
            ( List.Selection.select newCat model, Cmd.none )


updateSelected : (a -> a) -> Selection a -> Selection a
updateSelected f selection =
    case List.Selection.selected selection of
        Just selected ->
            List.Selection.map
                (\x ->
                    if x == selected then
                        f x
                    else
                        x
                )
                selection

        Nothing ->
            selection


incrementClicks : Cat -> Cat
incrementClicks cat =
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
        , catListView <| List.Selection.toList model
        , case List.Selection.selected model of
            Just cat ->
                catView cat

            Nothing ->
                text ""
        ]


catListView : List Cat -> Html Msg
catListView cats =
    ul [ id CatsList ] (List.map catListItemView cats)


catListItemView : Cat -> Html Msg
catListItemView cat =
    li [ class [ CatsListItem ], onClick (SwitchCat cat) ] [ text cat.name ]


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
