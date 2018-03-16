module Component.ItemList where

-- added START
import Prelude
import Component.Item (ItemQuery(..), ItemMessage(..), item)
import Data.Array (snoc, filter, length)
import Data.Array.ST.Iterator (next)
import Data.Map as M
import Data.Maybe (Maybe(..), fromMaybe)
-- import Halogen as H
import Halogen.HTML (a)
-- import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Model.Item (ItemId, initialItem)
import Model.ItemList (ItemList, initialItemList)
-- added END

--import Data.Maybe (Maybe(..))
import Halogen as H
import CSS (color, red)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
--import Prelude (class Eq, class Ord, type (~>), Unit, Void, const, pure, unit)

data Input a
  = Noop a

type State = Unit

data Slot = Slot

derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

-- added START
-- | The itemlist component query algebra.
data ItemListQuery a 
  = NewItem a
  | HandleItemMessage ItemId ItemMessage a 

-- | The slot value that is filled by items during the install process.
newtype ItemSlot = ItemSlot ItemId 
derive instance eqItemSlot :: Eq ItemSlot 
derive instance ordItemSlot :: Ord ItemSlot

-- | The itemlist component definition.
itemlist :: forall m. Applicative m => H.Component HH.HTML ItemListQuery Unit Void m 
itemlist = 
  H.parentComponent 
    {
      initialState: const initialItemList 
    , render 
    , eval 
    , receiver: const Nothing 
    }
  where 

  render :: ItemList -> H.ParentHTML ItemListQuery ItemQuery ItemSlot m 
  render st = 
    HH.div_
      [ HH.h1_ [ HH.text "Item list" ]
      , HH.p_ 
          [
            HH.button 
              [ HE.onClick (HE.input_ NewItem) ]
              [ HH.text "New Item"]
          ]
      , HH.ul_ (map renderItem st.items)    
      ]

  renderItem :: ItemId -> H.ParentHTML ItemListQuery ItemQuery ItemSlot m 
  renderItem itemId = 
    HH.slot 
      (ItemSlot itemId)
      (item initialItem)
      unit
      (HE.input (HandleItemMessage itemId))

  eval :: ItemListQuery ~> H.ParentDSL ItemList ItemListQuery ItemQuery ItemSlot Void m 
  eval (NewItem next) = do
    H.modify addItem
    pure next
  eval (HandleItemMessage p msg next) = do
    case msg of 
      NotifyRemove -> do 
        H.modify (removeItem p)
    pure next

-- | Adds an item to the current state.
addItem :: ItemList -> ItemList 
addItem st = st { nextId = st.nextId + 1, items = st.items `snoc` st.nextId }

-- | Removes an item from the current state.
removeItem :: ItemId -> ItemList -> ItemList 
removeItem itemId st = st { items = filter (_ /= itemId) st.items }
-- added END


-- to be removed START
ui :: forall m. H.Component HH.HTML Input Unit Void m
ui = H.component
  { initialState: const unit
  , render
  , eval
  , receiver: const Nothing
  }
  where
    render _ =
      HH.div_
        [ HH.h1 [CSS.style do color red] [ HH.text "Your Items" ]
        , HH.p_ [ HH.text "Snowy Owl" ]
        ]
    eval :: Input ~> H.ComponentDSL State Input Void m
    eval (Noop n) = pure n
-- to be removed END