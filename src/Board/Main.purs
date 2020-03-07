module Board.Main (component) where

import Prelude

import Board.Model (Action(..), CardUid(..), State)
import Board.View (view)
import Data.List (fromFoldable)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.HTML as HH
import Utils.FunctionOps ((|>))
import Web.Event.Event as Event

component :: forall q i o m. MonadEffect m => H.Component HH.HTML q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

initialState :: forall i. i -> State
initialState _ = { cards: [ { uid: CardUid "12345", title: "US 12 - Super US de la mort", column: 1, isDrag: false } ] |> fromFoldable, openCard: false }

render :: forall m. State -> H.ComponentHTML Action () m
render = view

handleAction ∷ forall o m. MonadEffect m => Action → H.HalogenM State Action () o m Unit
handleAction = case _ of
  OpenCard cardId -> 
    H.modify_ \st ->
      let openedCard cards = map (\c -> if c.uid == cardId then c { title= c.title <> " OPENED" } else c) cards
      in st { cards = openedCard st.cards }

  -- la carte est choisie
  DragStart cardId -> 
    H.modify_ \st -> st 

  -- la carte est déplacée
  DragOver cardId -> 
    H.modify_ \st -> 
      let dragCard cards = map (\c -> if(c.uid == cardId) then c {isDrag = true} else c) cards
      in st { cards = dragCard st.cards }

  -- la carte est relachée
  DragEnd cardId -> 
    H.modify_ \st -> 
      let dragCard cards = map (\c -> if(c.uid == cardId) then c {isDrag = false} else c) cards
      in st { cards = dragCard st.cards }

  -- la carte est déposée dans une nouvelle colone
  DropCard columnId -> 
    H.modify_ \st ->
      let draggedCard cards = map (\c -> if c.isDrag then c {column = columnId} else c) cards
      in  st { cards = draggedCard st.cards }

  PreventDefault e -> do
    H.liftEffect $ Event.preventDefault e   

  OpenCreateCardPanel ->   
    H.modify_ \st -> st { openCard = true }

  CancelAction ->   
    H.modify_ \st -> st { openCard = false }