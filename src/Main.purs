module Main where

import Prelude

import Effect (Effect)
import Board.Main as Board
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI Board.component unit body