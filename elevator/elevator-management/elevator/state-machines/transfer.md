# Transfer

*Transfer State Machine Diagram — version 3.6.0, Aug 5, 2026*

<!-- generated from transfer.xsm - do not edit -->

Instances are created into **WAITING FOR CABIN** by the `Execute` event.

Rows are the wait states. A cell marked **?** is an interaction event with no declared response — it defaults to can't happen, but nobody has said why. A blank cell is a completion event that cannot be received here.

The transient states — `Changing destination before cabin moves`, `Dispatching cabin`, `Request redirect`, `Match new destination of cabin`, `Check for cabin reversal`, `Check for active floor service`, `Canceling floor service`, `Delete` *(deletion)* — accept only their own completion event; every other event can't happen.

## State transition table

| | Dest change request | Ready to go | Cabin redirected | Cabin at destination | Requests cleared | Door closed |
|---|---|---|---|---|---|---|
| **WAITING FOR CABIN** | can't happen | can't happen | can't happen | can't happen | can't happen | ignore |
| **CABIN IN MOTION** | **Request redirect** | can't happen | **Match new destination of cabin** | **Check for cabin reversal** | can't happen | can't happen |
| **CALL IN PROGRESS** | ignore | can't happen | can't happen | can't happen | can't happen | **Canceling floor service** |
| **WAITING FOR REQUESTS TO CLEAR** | ignore | can't happen | can't happen | can't happen | **Delete** | ignore |

`Wait for cabin`, `Cabin dispatched`, `Stationary update`, `Redirect requested`, `Update in motion`, `Reversal checked`, `Call in progress`, `Wait to clear` are answered only by a transient state, so those columns are omitted.

## Non transition event responses

### WAITING FOR CABIN

| Event | Response | Explanation |
|---|---|---|
| Dest change request | can't happen | Execute event is sent from same state of Shaft that creates the Transfer. This event is also sent from Shaft, in a future state, so it will always be detected after transitioning out of this state. |
| Ready to go | can't happen | Cabin hasn’t yet been directed to the state where this event would be sent. |
| Cabin redirected | can't happen | Cabin hasn’t been directed to move yet. |
| Cabin at destination | can't happen | Cabin hasn’t been directed to move yet. |
| Requests cleared | can't happen | We haven’t yet tried to clear any stop or floor call requests yet, and they can’t clear themselves alone. (Even an administration clear would have to first delete this instance of transfer). |
| Door closed | ignore | Doors may open and close while waiting to hear back from the Cabin. But we don’t care about closing unless we are waiting for floor service to expire after arrival. |

### CABIN IN MOTION

| Event | Response | Explanation |
|---|---|---|
| Ready to go | can't happen | The Cabin has already reported this and cannot get back to a state where it can report it again without direction from this instance of Transfer, which won’t be triggered. |
| Requests cleared | can't happen | We haven’t yet tried to clear any stop or floor call requests yet, and they can’t clear themselves alone. (Even an administration clear would have to first delete this instance of transfer). |
| Door closed | can't happen | The doors cannot be open when a cabin is moving. So, if we hear that they are just closed in this state, something has gone very wrong! |

### CALL IN PROGRESS

| Event | Response | Explanation |
|---|---|---|
| Dest change request | ignore | Shaft may have picked a destination, but we can’t go there now. We will retrigger the search when this Transfer is deleted, so there is no danger of missing a request. |
| Ready to go | can't happen | This event can only be sent from the cabin just before it begins moving. And it can’t advance beyond that without direction from this instance. At this point the cabin has finished moving. |
| Cabin redirected | can't happen | This event can only be sent from the cabin when it is moving. But it can’t be moving in this state. |
| Cabin at destination | can't happen | The cabin has already arrived. |
| Requests cleared | can't happen | We haven’t yet tried to clear any stop or floor call requests yet, and they can’t clear themselves alone. (Even an administration clear would have to first delete this instance of transfer). |

### WAITING FOR REQUESTS TO CLEAR

| Event | Response | Explanation |
|---|---|---|
| Dest change request | ignore | Shaft may have picked a destination, but we can’t go there now. We will retrigger the search when this Transfer is deleted, so there is no danger of missing a request. |
| Ready to go | can't happen | This event can only be sent from the cabin just before it begins moving. And it can’t advance beyond that without direction from this instance. At this point the cabin has finished moving. |
| Cabin redirected | can't happen | This event can only be sent from the cabin when it is moving. But it can’t be moving in this state. |
| Cabin at destination | can't happen | The cabin has already arrived. |
| Door closed | ignore | Not likely to happen, but we just don’t care at this point. There is no critical synchronization with the door once the call in progress has been canceled. |

