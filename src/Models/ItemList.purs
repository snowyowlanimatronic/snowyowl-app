module Model.ItemList where

import Model.Item (ItemId)
  
type ItemList = 
  {
    items :: Array ItemId
  , nextId :: ItemId   
  }

initialItemList :: ItemList
initialItemList = 
  {
    items: []
  , nextId: 1  
  }