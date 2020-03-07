module Board.Model (State, Card, CardUid(..), Action(..)) where 

import Data.Eq (class Eq)
import Data.List.Types (List)
import Data.Newtype (class Newtype)
import Web.Event.Event (Event)

data Action = OpenCard CardUid 
    | DragStart CardUid 
    | DragOver CardUid 
    | DragEnd CardUid
    | DropCard Int 
    | PreventDefault Event
    | OpenCreateCardPanel
    | CancelAction

type State = { cards :: List Card 
             , openCard :: Boolean
             }

type Card = { uid :: CardUid
            , title :: String
            , column :: Int
            , isDrag :: Boolean
            }

newtype CardUid = CardUid String            
newtype ColumnId = ColumnId Int

derive instance newtypeCardUid :: Newtype CardUid _
derive newtype instance eqCardUid :: Eq CardUid