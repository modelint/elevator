# Accessible Shaft Level

*Accessible Shaft Level State Machine Diagram — version 3.1.3, May 12, 2019*

<!-- generated from asl.xsm - do not edit -->

Rows are the wait states. A cell marked **?** is an interaction event with no declared response — it defaults to can't happen, but nobody has said why. A blank cell is a completion event that cannot be received here.

The transient states — `Registering stop`, `Registering floor call`, `Requesting service`, `Clear stop request`, `Clear floor request` — accept only their own completion event; every other event can't happen.

## State transition table

| | Stop request | Floor calling | Stop serviced | Serviced floor request |
|---|---|---|---|---|
| **NOT REQUESTED** | **Registering stop** | **Registering floor call** | can't happen | can't happen |
| **REQUESTED** | **Registering stop** | **Registering floor call** | **Clear stop request** | **Clear floor request** |

`All requests cleared`, `Floor call registered`, `Stop registered`, `Wait for service`, `Opposite floor call pending`, `Check stop request` are answered only by a transient state, so those columns are omitted.

## Non transition event responses

### NOT REQUESTED

| Event | Response | Explanation |
|---|---|---|
| Stop serviced | can't happen | Transfer only sends this signal to a requested ASLEV. So, something is out of sync and horribly wrong if this happens. |
| Serviced floor request | can't happen | Transfer only sends this signal to a requested ASLEV. So, something is out of sync and horribly wrong if this happens. |

### REQUESTED

*Every event is either a transition or a systematic can't happen.*

