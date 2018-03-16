module Component.Container where

import Prelude

import Component.Button as Button
import Control.Monad.Eff.Exception (stack)
import Control.Monad.State (state)
import Data.Maybe (Maybe(..), maybe)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

--import Data.Maybe (Maybe(..))
--import Halogen as H
--import Halogen.HTML as HH
--import Prelude (class Eq, class Ord, type (~>), Unit, Void, const, pure, unit)

--data Input a
--  = Noop a

--type State = Unit

--data Slot = Slot

--derive instance eqSlot :: Eq Slot
--derive instance ordSlot :: Ord Slot

data Query a
--  = Noop a
  = HandleButton Button.Message a
  | CheckButtonState a

type State =
  { toggleCount :: Int
  , buttonState :: Maybe Boolean
  }

--type State = Unit

-- Values of the type Slot are used as the IDs for child components
-- in the rendered HTML.
data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

--data Slot = Slot
--derive instance eqSlot :: Eq Slot
--derive instance ordSlot :: Ord Slot

--ui :: forall m. H.Component HH.HTML Input Unit Void m
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
    { toggleCount: 0
    , buttonState: Nothing }

    --render _ =
    --  HH.div_
    --    [ HH.h1_ [ HH.text "Your Container" ]
    --    , HH.p_ [ HH.text "what a nice container!" ]
    --    ]

  render :: State -> H.ParentHTML Query Button.Query Slot m 
  render state = 
    HH.div_
      [ HH.slot Slot Button.myButton unit (HE.input HandleButton) 
      , HH.p_
          [ HH.text ("Button has been toggled " <> show state.toggleCount <> " time(s)") ]
      , HH.p_
          [ HH.text
            $ "Last time I checked, the button was: "
            <> (maybe "(not checked yet)" (if _ then "on" else "off") state.buttonState)
            <> ". "
          , HH.button
            [ HE.onClick (HE.input_ CheckButtonState) ]
            [ HH.text "Check now"]
          ]
      ]

    --eval :: Input ~> H.ComponentDSL State Input Void m
    --eval :: Query ~> H.ComponentDSL State Query Void m
    --eval (Noop n) = pure n
  eval :: Query ~> H.ParentDSL State Query Button.Query Slot Void m
  eval = case _ of
    HandleButton (Button.Toggled _) next -> do
      H.modify (\st -> st { toggleCount = st.toggleCount + 1 })
      pure next
    CheckButtonState next -> do
      buttonState <- H.query Slot $ H.request Button.IsOn
      H.modify (_ { buttonState = buttonState })
      pure next



--component :: forall m. H.Component HH.HTML Query Unit Void m
--component =
--  H.parentComponent
--    { initialState: const initialState
--    , render
--    , eval
--    , receiver: const Nothing
--    }
--  where
--
--  initialState :: State
--  initialState =
--    { toggleCount: 0
--    , buttonState: Nothing }

--  render :: State -> H.ParentHTML Query Button.Query Slot m
--  render state =
--    HH.div_
--      --[ HH.slot ButtonSlot Button.myButton unit (HE.input HandleButton)
--      [ HH.slot Slot Button.myButton unit (HE.input HandleButton)
--      , HH.p_
--          [ HH.text ("Button has been toggled " <> show state.toggleCount <> " time(s)") ]
--      , HH.p_
--          [ HH.text
--              $ "Last time I checked, the button was: "
--              <> (maybe "(not checked yet)" (if _ then "on" else "off") state.buttonState)
--              <> ". "
--          , HH.button
--              [ HE.onClick (HE.input_ CheckButtonState) ]
--              [ HH.text "Check now" ]
--          ]
--      ]

--  eval :: Query ~> H.ParentDSL State Query Button.Query Slot Void m
--  eval = case _ of
--    HandleButton (Button.Toggled _) next -> do
--      H.modify (\st -> st { toggleCount = st.toggleCount + 1 })
--      pure next
--    CheckButtonState next -> do
--      --buttonState <- H.query ButtonSlot $ H.request Button.IsOn
--      buttonState <- H.query Slot $ H.request Button.IsOn
--      H.modify (_ { buttonState = buttonState })
--      pure next