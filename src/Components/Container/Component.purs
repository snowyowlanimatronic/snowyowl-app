module Container.Component where

import Prelude

import CSS as CB
import ComponentB.Component as ComponentB
import ComponentC.Component as ComponentC
import SubContainerD.Component as SubContainerD
--import Container.Component.Query (Query)
import Container.Component.State (State)
import Control.Monad.Eff.Exception (stack)
import Control.Monad.State (state)
import Data.Either.Nested (Either3)
import Data.Functor.Coproduct.Nested (Coproduct3)
import Data.Maybe (Maybe(..), maybe)
import Halogen as H
import Halogen.Component.ChildPath as CP
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
--import ItemList.Component as ComponentA

data Query a = ReadStates a

type ChildQuery = Coproduct3 ComponentB.Query ComponentC.Query SubContainerD.Query
type ChildSlot = Either3 Unit Unit Unit

-- Values of the type Slot are used as the IDs for child components
-- in the rendered HTML.
data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

ui :: forall m. H.Component HH.HTML Query Unit Void m
ui = 
  H.parentComponent
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState =
    { b: Nothing
    , c: Nothing
    --, d: Nothing   
    }   

  render :: State -> H.ParentHTML Query ChildQuery ChildSlot m 
  render state = 
    HH.div_
    [ HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h2_ [ HH.text "Component B" ]
        , HH.slot' CP.cp1 unit ComponentB.component unit absurd
        ]
    , HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h2_ [ HH.text "Component C" ]
        , HH.slot' CP.cp2 unit ComponentC.component unit absurd
        ]
    , HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h2_ [ HH.text "SubContainer D" ]
        , HH.slot' CP.cp3 unit SubContainerD.ui unit absurd
        ]   
    , HH.p_
        [ HH.text "Last observed states:"]
    , HH.ul_
        [ HH.li_ [ HH.text ("Component B: " <> show state.b) ]
        , HH.li_ [ HH.text ("Component C: " <> show state.c) ]
        --, HH.li_ [ HH.text ("Component D: " <> show state.d) ]
        ]
    , HH.button
        [ HE.onClick (HE.input_ ReadStates) ]
        [ HH.text "Check states now" ]
    ]

  eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Void m
  eval = case _ of
    ReadStates next -> do
      b <- H.query' CP.cp1 unit (H.request ComponentB.GetCount)
      c <- H.query' CP.cp2 unit (H.request ComponentC.GetValue)
      --d <- H.query' CP.cp3 unit (H.request ComponentD.GetCount)
      H.put { b, c }
      pure next