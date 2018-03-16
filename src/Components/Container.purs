module Component.Container where

import Prelude

import CSS as CB
--import Component.Button as Button
import Component.ComponentA as ComponentA
import Component.ComponentB as ComponentB
import Component.ComponentC as ComponentC
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

data Query a
  -- = HandleButton Button.Message a
  -- | CheckButtonState a
  -- | ReadStates a
  = ReadStates a

type State =
  --{ 
  --toggleCount :: Int
  --, buttonState :: Maybe Boolean
  --, a :: Maybe Boolean
  --, b :: Maybe Int
  --, c :: Maybe String
  --}
  { a :: Maybe Boolean
  , b :: Maybe Int
  , c :: Maybe String
  }

type ChildQuery = Coproduct3 ComponentA.Query ComponentB.Query ComponentC.Query
type ChildSlot = Either3 Unit Unit Unit

-- Values of the type Slot are used as the IDs for child components
-- in the rendered HTML.
data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

--ui :: forall m. H.Component HH.HTML Query Unit Void m
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
  --initialState =
    --{ toggleCount: 0
    --, buttonState: Nothing 
    --, a: Nothing
    --, b: Nothing
    --, c: Nothing
    --}
  initialState =
    { a: Nothing
    , b: Nothing
    , c: Nothing
    } 

  --render :: State -> H.ParentHTML Query Button.Query Slot m 
  render :: State -> H.ParentHTML Query ChildQuery ChildSlot m 
  render state = 
    --HH.div_
    --  [ HH.slot Slot Button.myButton unit (HE.input HandleButton) 
    --  , HH.p_
    --      [ HH.text ("Button has been toggled " <> show state.toggleCount <> " time(s)") ]
    --  , HH.p_
    --      [ HH.text
    --        $ "Last time I checked, the button was: "
    --        <> (maybe "(not checked yet)" (if _ then "on" else "off") state.buttonState)
    --        <> ". "
    --      , HH.button
    --        [ HE.onClick (HE.input_ CheckButtonState) ]
    --        [ HH.text "Check now" ]
    --      ]
    --  ]
    HH.div_
    [ HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h1_ [ HH.text "Component A" ]
        , HH.slot' CP.cp1 unit ComponentA.component unit absurd
        ]
    , HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h1_ [ HH.text "Component B" ]
        , HH.slot' CP.cp2 unit ComponentB.component unit absurd
        ]
    , HH.div
        [ HP.class_ (H.ClassName "box")]
        [ HH.h1_ [ HH.text "Component C" ]
        , HH.slot' CP.cp3 unit ComponentC.component unit absurd
        ]
    , HH.p_
        [ HH.text "Last observed states:"]
    , HH.ul_
        [ HH.li_ [ HH.text ("Component A: " <> show state.a) ]
        , HH.li_ [ HH.text ("Component B: " <> show state.b) ]
        , HH.li_ [ HH.text ("Component C: " <> show state.c) ]
        ]
    , HH.button
        [ HE.onClick (HE.input_ ReadStates) ]
        [ HH.text "Check states now" ]
    ]

  --eval :: Query ~> H.ParentDSL State Query Button.Query Slot Void m
  eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Void m
  eval = case _ of
    --HandleButton (Button.Toggled _) next -> do
    --  H.modify (\st -> st { toggleCount = st.toggleCount + 1 })
    --  pure next
    --CheckButtonState next -> do
    --  buttonState <- H.query Slot $ H.request Button.IsOn
    --  H.modify (_ { buttonState = buttonState })
    --  pure next
    ReadStates next -> do
      a <- H.query' CP.cp1 unit (H.request ComponentA.GetState)
      b <- H.query' CP.cp2 unit (H.request ComponentB.GetCount)
      c <- H.query' CP.cp3 unit (H.request ComponentC.GetValue)
      H.put { a, b, c }
      pure next