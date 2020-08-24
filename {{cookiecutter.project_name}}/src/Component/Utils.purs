module Component.Utils where

import Prelude {% if cookiecutter.user == "y" %}
import Control.Monad.Rec.Class      (forever) {% endif %}
import Data.Const                   (Const) {% if cookiecutter.user == "y" %}
import Effect.Aff                   (error
                                    ,forkAff
                                    ,killFiber)
import Effect.Aff.Bus               as Bus
import Effect.Aff.Class             (class MonadAff) {% endif %}
import Halogen                      as H {% if cookiecutter.user == "y" %}
import Halogen.Query.EventSource    as ES {% endif %}

-- Helper type for components with  
-- no queries or messages
-- see: https://github.com/thomashoneyman/purescript-halogen-realworld/pull/26
type OpaqueSlot = H.Slot (Const Void) Void
{% if cookiecutter.user == "y" %}
busEventSource :: forall m r act. MonadAff m => Bus.BusR' r act -> ES.EventSource m act
busEventSource bus =
  ES.affEventSource \emitter -> do
    fiber <- forkAff $ forever $ ES.emit emitter =<< Bus.read bus
    pure (ES.Finalizer (killFiber (error "Event source closed") fiber))
{% endif %}
