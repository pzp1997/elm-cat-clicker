module CatClickerCss exposing (css)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import SharedStyles exposing (homepageNamespace, CssClasses(..), CssIds(..))


css : Stylesheet
css =
    (stylesheet << namespace homepageNamespace.name)
        [ class TextCenter
            [ textAlign center ]
        , class CatImg
            [ width (pct 60)
            , maxWidth (px 480)
            , minWidth (px 320)
            ]
        , id CatsList
            [ textAlign center
            , padding (px 0)
            , listStyle none
            ]
        , class CatsListItem
            [ display inlineBlock
            , padding2 (px 0) (px 10)
            , fontWeight bold
            ]
        ]
