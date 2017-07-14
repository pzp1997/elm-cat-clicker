module CatClicker exposing (..)

import Element exposing (column, el, empty, image, row)
import Element.Attributes as Attr exposing (center, spacing)
import Element.Events exposing (onClick)
import Html exposing (Html)
import List.Selection exposing (Selection)
import Style exposing (style)
import Style.Font as Font


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
    [ Cat "Tom" "http://i.imgur.com/A9BcZD9.jpg" 0
    , Cat "Captain McFurry" "http://i.imgur.com/NqK74g7.jpg" 0
    , Cat "Snowball" "http://i.imgur.com/yJYtfBd.jpg" 0
    ]


init : ( Model, Cmd Msg )
init =
    ( selectFirst <| List.Selection.fromList catData, Cmd.none )


selectFirst : Selection a -> Selection a
selectFirst selection =
    case List.head <| List.Selection.toList selection of
        Just hd ->
            List.Selection.select hd selection

        Nothing ->
            selection



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


type alias El =
    Element.Element Styles Never Msg


type Styles
    = None
    | SansSerif
    | H1
    | H2
    | H4


stylesheet : Style.StyleSheet Styles Never
stylesheet =
    Style.stylesheet
        [ style None []
        , style SansSerif [ Font.typeface [ "Arial", "sans-serif" ] ]
        , style H1 [ Font.size 36, Font.weight 500 ]
        , style H2 [ Font.size 30, Font.weight 500 ]
        , style H4 [ Font.size 18, Font.weight 500 ]
        ]


view : Model -> Html Msg
view model =
    Element.viewport stylesheet <|
        column SansSerif
            [ center, Attr.verticalCenter, spacing 30 ]
            [ h1 "Click the cat!"
            , selectorView <| List.Selection.toList model
            , el None [ Attr.verticalCenter ] <|
                case List.Selection.selected model of
                    Just cat ->
                        catView cat

                    Nothing ->
                        empty
            ]


selectorView : List Cat -> El
selectorView cats =
    let
        selectOption cat =
            el None [ onClick (SwitchCat cat) ] (h4 cat.name)
    in
        row None [ spacing 15 ] (List.map selectOption cats)


catView : Cat -> El
catView cat =
    column None
        [ center, spacing 5 ]
        [ h2 cat.name
        , image cat.imgSrc
            None
            [ Attr.alt ("Picture of " ++ cat.name)
            , onClick ClickCat
            , Attr.height (Attr.px 320)
            ]
            empty
        , h2 <| toString cat.clicks ++ " clicks"
        ]


h1 : String -> El
h1 text =
    el H1 [] (Element.text text)


h2 : String -> El
h2 text =
    el H2 [] (Element.text text)


h4 : String -> El
h4 text =
    el H4 [] (Element.text text)
