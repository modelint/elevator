# Cabin

*Cabin State Machine Diagram — version 3.6.0, August 3, 2026*

<!-- generated from cabin.xsm - do not edit -->

Rows are the wait states. A cell marked **?** is an interaction event with no declared response — it defaults to can't happen, but nobody has said why. A blank cell is a completion event that cannot be received here.

The transient states — `Update location`, `Notify transfer`, `Request destination`, `Are we already there?`, `Set emergency stop`, `Requesting transport` — accept only their own completion event; every other event can't happen.

## State transition table

| | Doors secure | New transfer | Take out of service | Arrived at floor | Cabin stopping | Try redirect | Transport unavailable | Go | Destination update | Passing floor |
|---|---|---|---|---|---|---|---|---|---|---|
| **READY TO GO** | can't happen | can't happen | **OUT OF SERVICE** | can't happen | can't happen | can't happen | can't happen | **Requesting transport** | can't happen | can't happen |
| **SECURING DOORS** | **READY TO GO** | can't happen | **OUT OF SERVICE** | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen |
| **PICKUP DROPOFF** | can't happen | **Are we already there?** | **OUT OF SERVICE** | can't happen | can't happen | ignore | can't happen | can't happen | can't happen | can't happen |
| **OUT OF SERVICE** | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen | can't happen |
| **EMERGENCY BRAKING** | can't happen | can't happen | ignore | ignore | **Set emergency stop** | ignore | ignore | can't happen | ignore | ignore |
| **MOVING** | can't happen | can't happen | **EMERGENCY BRAKING** | **PICKUP DROPOFF** | can't happen | **Request destination** | **OUT OF SERVICE** | can't happen | **Notify transfer** | **Update location** |

`Prepare to move`, `Already there`, `Change requested`, `Transport in progress`, `Transfer notified`, `Location updated` are answered only by a transient state, so those columns are omitted.

## Non transition event responses

### READY TO GO

| Event | Response | Explanation |
|---|---|---|
| Doors secure | can't happen | Doors can’t get back to the state where they report this until we’ve gone through another move cycle and have been locked again. |
| New transfer | can't happen | Transfer already exists and won’t be deleted until we get through another move cycle. |
| Arrived at floor | can't happen | Cabin is already stopped. |
| Cabin stopping | can't happen | No emergency stop was requested. |
| Try redirect | can't happen | We have a new Transfer and it can’t ask for a redirect until we get moving again. |
| Transport unavailable | can't happen | Cannot occur if cabin is not moving |
| Destination update | can't happen | Cannot occur if cabin is not moving |
| Passing floor | can't happen | Cannot occur if cabin is not moving |

### SECURING DOORS

| Event | Response | Explanation |
|---|---|---|
| New transfer | can't happen | Transfer already exists and won’t be deleted until we get through another move cycle. |
| Arrived at floor | can't happen | Cabin is already stopped. |
| Cabin stopping | can't happen | No emergency stop was requested. |
| Try redirect | can't happen | We have a new Transfer and it can’t ask for a redirect until we get moving again. |
| Transport unavailable | can't happen | Cannot occur if cabin is not moving |
| Go | can't happen | No, the whole point is to hold here until the transfer acknowledges that door is in the Locked state and the cabin is stationary. |
| Destination update | can't happen | Cannot occur if cabin is not moving |
| Passing floor | can't happen | Cannot occur if cabin is not moving |

### PICKUP DROPOFF

| Event | Response | Explanation |
|---|---|---|
| Doors secure | can't happen | This only happens in response to lock requested in Securing Doors state. And we don’t leave that state until the event happens. |
| Arrived at floor | can't happen | Cabin is already stopped. |
| Cabin stopping | can't happen | No emergency stop was requested. |
| Try redirect | ignore | Possible if Transfer requests redirect just as arrival occurs. We can safely ignore because when the Transfer completes it will trigger another search for service. |
| Transport unavailable | can't happen | Cannot occur if cabin is not moving |
| Go | can't happen | Transfer can’t send this event until after we advance to the Locking Transfer state. |
| Destination update | can't happen | Cannot occur if cabin is not moving |
| Passing floor | can't happen | Cannot occur if cabin is not moving |

### OUT OF SERVICE

| Event | Response | Explanation |
|---|---|---|
| Doors secure | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| New transfer | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Take out of service | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Arrived at floor | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Cabin stopping | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Try redirect | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Transport unavailable | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Go | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Destination update | can't happen | Final state. Interacting instances should verify in service status before sending any events. |
| Passing floor | can't happen | Final state. Interacting instances should verify in service status before sending any events. |

### EMERGENCY BRAKING

| Event | Response | Explanation |
|---|---|---|
| Doors secure | can't happen | The doors must already be closed if we are braking. |
| New transfer | can't happen | The transfer in progress has not completed, so we can't get another one now. |
| Take out of service | ignore | We are already going out of service, so no need to react. |
| Arrived at floor | ignore | Doesn't matter since we are going out of service. |
| Try redirect | ignore | Doesn't matter since we are going out of service. |
| Transport unavailable | ignore | Doesn't matter since we are going out of service. |
| Go | can't happen | Transfer can’t send this event until after we advance to the Locking Transfer state. |
| Destination update | ignore | Doesn't matter since we are going out of service. |
| Passing floor | ignore | Doesn't matter since we are going out of service. |

### MOVING

| Event | Response | Explanation |
|---|---|---|
| Doors secure | can't happen | This is a serious ‘out of sync’ error. The doors must be secure (closed and locked) while the cabin is moving. |
| New transfer | can't happen | The transfer has already directed the cabin to move and it only does it once, so it can’t happen again. |
| Cabin stopping | can't happen | No emergency stop was requested. |
| Go | can't happen | The transfer has already directed us to go and it only does this once during its lifecycle. |

