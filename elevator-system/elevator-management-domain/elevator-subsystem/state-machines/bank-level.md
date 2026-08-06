# Bank Level

*Bank Level State Machine Diagram — version 0.2.2, January 12, 2026*

<!-- generated from bank-level.xsm - do not edit -->

Rows are the wait states. A cell marked **?** is an interaction event with no declared response — it defaults to can't happen, but nobody has said why. A blank cell is a completion event that cannot be received here.

The transient states — `Select cabin`, `Clear request` — accept only their own completion event; every other event can't happen.

## State transition table

| | Floor requested | Clear floor request |
|---|---|---|
| **WAITING FOR CALL** | **Select cabin** | **Clear request** |

`Cabin selected`, `Request cleared` are answered only by a transient state, so those columns are omitted.

## Non transition event responses

### WAITING FOR CALL

*Every event is either a transition or a systematic can't happen.*

