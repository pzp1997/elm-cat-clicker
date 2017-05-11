port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import CatClickerCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "index.css", Css.File.compile [ CatClickerCss.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
