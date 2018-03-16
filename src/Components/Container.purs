module Component.Container where

import Prelude

import Component.Button as Button
import Control.Monad.Eff.Exception (stack)
import Control.Monad.State (state)
import Data.Maybe (Maybe(..), maybe)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

data Query a
  = HandleButton Button.Message a
  | CheckButtonState a

type State =
  { toggleCount :: Int
  , buttonState :: Maybe Boolean
  }

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
    { toggleCount: 0
    , buttonState: Nothing }

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

  eval :: Query ~> H.ParentDSL State Query Button.Query Slot Void m
  eval = case _ of
    HandleButton (Button.Toggled _) next -> do
      H.modify (\st -> st { toggleCount = st.toggleCount + 1 })
      pure next
    CheckButtonState next -> do
      buttonState <- H.query Slot $ H.request Button.IsOn
      H.modify (_ { buttonState = buttonState })
      pure next