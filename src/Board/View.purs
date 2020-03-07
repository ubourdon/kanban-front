module Board.View (view) where


import Board.Model (Action(..), Card, State)
import CSS (CSS, Color, FontWeight(..), backgroundColor, black, border, boxShadow, color, em, fixed, fontSize, fontWeight, fromHexString, fromString, height, key, left, marginRight, marginTop, outset, padding, paddingLeft, pct, position, px, rgba, top, vh, weight, white, width, zIndex)
import CSS.Display (display, grid, displayNone, block)
import Color.Scheme.Clrs (red)
import Data.Array ((..))
import Data.List (toUnfoldable, filter)
import Data.List.Types (List)
import Data.Maybe (fromMaybe, Maybe(..))
import Halogen as H
import Halogen.HTML (button, div, h2, input, text)
import Halogen.HTML.CSS as HCSS
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties (draggable, placeholder)
import Prelude (($), discard, map, (==), show, (<>))
import Utils.FunctionOps ((|>))
import Web.HTML.Event.DragEvent (toEvent)

view :: forall m. State -> H.ComponentHTML Action () m
view state =
  let columnsToDisplay = (columns 2 state)
  in div
      [ HCSS.style do backgroundColor $ hex "#00aecc" ]
      [ div 
          [ HCSS.style do paddingLeft $ pct 2.0 ] 
          [ button 
              [ HCSS.style do height $ px 30.0 
                              cursorProperty
              , HE.onClick \_ -> Just OpenCreateCardPanel                
              ] 
              [ text "Créer une carte" ] ]
      , createCard state
      , div
          [ HCSS.style do width $ pct 96.0
                          height $ vh 97.0
                          padding (pct 2.0) (pct 2.0) (pct 0.0) (pct 2.0)
                          display grid
                          gridColumnProperty "auto 1fr"
          ]
          columnsToDisplay
      ] 

createCard state = 
  div [ HCSS.style do if state.openCard then display block else display displayNone 
                      --if state.openCard then  else display displayNone 
                      position fixed
                      top $ pct 0.0
                      left $ pct 0.0
                      width $ pct 100.0
                      height $ pct 100.0
                      backgroundColor black
                      zIndex 1999
                      opacity "0.5"
      , HE.onClick \_ -> Just CancelAction                  
      ]
      [ div 
          [ HCSS.style do if state.openCard then display block else display displayNone
                          position fixed 
                          top $ pct 50.0
                          left $ pct 50.0
                          width $ pct 40.0
                          zIndex 2000
                          backgroundColor $ hex "#ebecf0"
                          border outset (px 3.0) (hex "#555555")
          ] 
          [ h2 [] [ text "Créer une carte" ] 
          --, input [] []
          ]
      ]    

columns :: forall m. Int -> State -> Array (H.ComponentHTML Action () m)
columns n state = map (column state.cards) range
  where range = (1..n)

column :: forall m. List Card -> Int -> H.ComponentHTML Action () m
column cards i = 
  let cardForThisColumn = filter (\c -> i == c.column) cards
  in
    div 
      [ HCSS.style do gridColumn $ show i
                      width $ px 190.0
                      height $ pct 96.0
                      backgroundColor $ hex "#ebecf0"
                      marginRight $ px 10.0
                      padding (px 20.0) (px 5.0) (px 5.0) (px 5.0)  
      , HE.onDragOver \e -> Just $ PreventDefault (toEvent e)
      , HE.onDrop \_ -> Just (DropCard i)                
      ]
      [ h2 
        [ HCSS.style do color $ hex "#172b4d" 
                        fontSize $ px 14.0
                        paddingLeft $ px 4.0
                        marginTop $ px 0.0
                        fontWeight $ weight 600.0
        ] 
        [ text $ "colonne" <> show i ]
      , div 
          []
          (map card cardForThisColumn |> toUnfoldable)
      ]          

card :: forall m. Card -> H.ComponentHTML Action () m
card c = 
  div 
    [ HCSS.style do backgroundColor white
                    padding (px 10.0) (px 5.0) (px 10.0) (px 5.0)
                    fontSize $ em 0.8
                    if c.isDrag then display displayNone else display block
                    boxShadow (px 0.0) (px 1.0) (px 0.0) (rgba 9 30 66 0.25)  
                    cursorProperty                  
    , draggable true
    , HE.onMouseUp \_ -> Just (OpenCard c.uid)
    , HE.onDragStart \_ -> Just (DragStart c.uid)
    , HE.onDragOver \_ -> Just (DragOver c.uid)    
    , HE.onDragEnd \_ -> Just (DragEnd c.uid)
    ]
    [ text c.title ]

hex :: String -> Color
hex s = fromMaybe red (fromHexString s)

gridColumnProperty :: String -> CSS
gridColumnProperty = key $ fromString "grid-template-columns"

cursorProperty :: CSS
cursorProperty = 
  let prop = key $ fromString "cursor"
  in prop "pointer"  

opacity :: String -> CSS
opacity = key $ fromString "opacity"

gridColumn :: String -> CSS
gridColumn = key $ fromString "grid-column"