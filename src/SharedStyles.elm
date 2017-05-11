module SharedStyles exposing (..)

import Html.CssHelpers exposing (withNamespace, Namespace)


type CssClasses
    = TextCenter
    | CatImg
    | CatsListItem


type CssIds
    = CatsList


homepageNamespace : Namespace String class id msg
homepageNamespace =
    withNamespace "catClicker"
