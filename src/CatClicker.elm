module CatClicker exposing (..)

import Element exposing (column, el, empty, h1, h2, h4, image, row, text)
import Element.Attributes exposing (center, height, px, spacing, verticalCenter)
import Element.Events exposing (onClick)
import Html exposing (Html)
import List.Selection as Selection exposing (Selection)
import Style exposing (StyleSheet, style, styleSheet)
import Style.Font exposing (font, sansSerif, typeface)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
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


model : Model
model =
    Selection.fromList catData
        |> case catData of
            [] ->
                identity

            hd :: _ ->
                Selection.select hd



-- UPDATE


type Msg
    = ClickCat
    | SwitchCat Cat


update : Msg -> Model -> Model
update msg model =
    case msg of
        ClickCat ->
            Selection.mapSelected
                { selected = incrementClicks, rest = identity }
                model

        SwitchCat newCat ->
            Selection.select newCat model


incrementClicks : Cat -> Cat
incrementClicks cat =
    { cat | clicks = cat.clicks + 1 }



-- VIEW


type alias El =
    Element.Element Styles Never Msg


type Styles
    = None
    | SansSerif


stylesheet : StyleSheet Styles Never
stylesheet =
    styleSheet
        [ style None []
        , style SansSerif [ typeface [ font "Arial", sansSerif ] ]
        ]


view : Model -> Html Msg
view model =
    Element.viewport stylesheet <|
        column SansSerif
            [ center, verticalCenter, spacing 30 ]
            [ h1 None [] <| text "Click the cat!"
            , selectorView <| Selection.toList model
            , el None [ verticalCenter ] <|
                Element.whenJust (Selection.selected model) catView
            ]


selectorView : List Cat -> El
selectorView cats =
    let
        selectOption cat =
            el None [ onClick (SwitchCat cat) ] (h4 None [] <| text cat.name)
    in
        row None [ spacing 15 ] (List.map selectOption cats)


catView : Cat -> El
catView cat =
    column None
        [ center, spacing 5 ]
        [ h2 None [] <| text cat.name
        , image
            None
            [ onClick ClickCat, height (px 320) ]
            { src = cat.imgSrc, caption = "Picture of " ++ cat.name }
        , h2 None [] <| text (toString cat.clicks ++ " clicks")
        ]
