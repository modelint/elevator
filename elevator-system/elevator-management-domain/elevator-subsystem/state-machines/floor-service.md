# Floor Service

*Floor Service State Machine Diagram — version 3.3.0, October 20, 2025*

<!-- generated from floor-service.xsm - do not edit -->

Rows are the wait states. A cell marked **?** is an interaction event with no declared response — it defaults to can't happen, but nobody has said why. A blank cell is a completion event that cannot be received here.

The transient states — `Check bank level type` — accept only their own completion event; every other event can't happen.

## State transition table

| | Cabin arrived | Cancel |
|---|---|---|
| **WAITING FOR CABIN** | **Check bank level type** | can't happen |
| **HOLDING SERVICE DIRECTION** | can't happen | **COMPLETED** |
| **COMPLETED** | can't happen | can't happen |

`Middle floor`, `Top bottom floor` are answered only by a transient state, so those columns are omitted.

## Non transition event responses

### WAITING FOR CABIN

| Event | Response | Explanation |
|---|---|---|
| Cancel | can't happen | Transfer cannot be out of sync with the floor service. It is the source of both external events. |

### HOLDING SERVICE DIRECTION

| Event | Response | Explanation |
|---|---|---|
| Cabin arrived | can't happen | Transfer cannot be out of sync with the floor service. It is the source of both external events. |

### COMPLETED

| Event | Response | Explanation |
|---|---|---|
| Cabin arrived | can't happen | Transfer cannot be out of sync with the floor service. It is the source of both external events. |
| Cancel | can't happen | Transfer cannot be out of sync with the floor service. It is the source of both external events. |

