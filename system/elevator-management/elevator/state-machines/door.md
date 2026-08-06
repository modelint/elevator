# Door

*Door State Machine — version 3.4.4, April 30, 2026*

<!-- generated from door.xsm - do not edit -->

Rows are the wait states. A cell marked **?** is an interaction event with no declared response — it defaults to can't happen, but nobody has said why. A blank cell is a completion event that cannot be received here.

The transient states — `Cancel open delay`, `Count block` — accept only their own completion event; every other event can't happen.

## State transition table

| | Door opened | Passenger open | Passenger close | Time to close | Hold released | Door closed | Lock | Unlock | Door blocked |
|---|---|---|---|---|---|---|---|---|---|
| **OPENING** | **OPEN** | ignore | **CLOSING** | can't happen | ignore | can't happen | ignore | can't happen | can't happen |
| **OPEN** | can't happen | ignore | **Cancel open delay** | **HOLDING OPEN** | ignore | can't happen | ignore | can't happen | can't happen |
| **HOLDING OPEN** | can't happen | ignore | ignore | can't happen | **CLOSING** | can't happen | ignore | can't happen | can't happen |
| **CLOSING** | can't happen | **OPENING** | ignore | can't happen | ignore | **CLOSED** | ignore | can't happen | **Count block** |
| **CLOSED** | can't happen | **OPENING** | ignore | can't happen | ignore | can't happen | **LOCKED** | can't happen | can't happen |
| **LOCKED** | can't happen | ignore | ignore | can't happen | ignore | can't happen | can't happen | **OPENING** | can't happen |
| **CANNOT CLOSE** | can't happen | can't happen | can't happen | can't happen | ignore | can't happen | can't happen | can't happen | can't happen |

`Open delay canceled`, `Keep trying`, `Cannot close door` are answered only by a transient state, so those columns are omitted.

## Non transition event responses

### OPENING

| Event | Response | Explanation |
|---|---|---|
| Passenger open | ignore | The passenger can hit the open button all they like at this point, but it will be ignored since the door is, in fact, opening now. |
| Time to close | can't happen | This is a delayed event that is canceled on any path that enters the current state. |
| Hold released | ignore | This condition is saved as the Hold attribute status and checked in the HOLDING OPEN state. |
| Door closed | can't happen | Door is opening, so it should not detect ‘closed’. |
| Lock | ignore | There’s nothing to do at this point, but we assume the lock attribute will be set and we will check it later, so the event info is not lost. |
| Unlock | can't happen | Cabin is not able to progress to a state where it can send this event while we are opening the door. |
| Door blocked | can't happen | Block can only be reported while closing the door. (door jams while opening are not modeled, in this release anyway) |

### OPEN

| Event | Response | Explanation |
|---|---|---|
| Door opened | can't happen | The door is already open. |
| Passenger open | ignore | Door is already open, so this is ignored. |
| Hold released | ignore | This condition is saved as the Hold attribute status and checked in the HOLDING OPEN state. |
| Door closed | can't happen | The door is open and cannot instantaneously be closed. |
| Lock | ignore | There’s nothing to do at this point, but we assume the lock attribute will be set and we will check it later, so the event info is not lost. |
| Unlock | can't happen | Cabin is not able to progress to a state where it can send this event while we are opening the door. |
| Door blocked | can't happen | Makes no sense if the door is open. |

### HOLDING OPEN

| Event | Response | Explanation |
|---|---|---|
| Door opened | can't happen | The door is already open. |
| Passenger open | ignore | Door is already open, so this is ignored. |
| Passenger close | ignore | Passenger is simultaneously requesting hold open and close. Open overrides, so we just ignore. |
| Time to close | can't happen | This is a delayed event that is canceled on any path that enters the current state. |
| Door closed | can't happen | The door is open and cannot instantaneously be closed. |
| Lock | ignore | There’s nothing to do at this point, but we assume the lock attribute will be set and we will check it later, so the event info is not lost. |
| Unlock | can't happen | Cabin is not able to progress to a state where it can send this event while we are opening the door. |
| Door blocked | can't happen | Makes no sense if the door is open. |

### CLOSING

| Event | Response | Explanation |
|---|---|---|
| Door opened | can't happen | If we are closing, there’s no way to become open. |
| Passenger close | ignore | We’re already closing, so just ignore. |
| Time to close | can't happen | This is a delayed event that is canceled on any path that enters the current state. |
| Hold released | ignore | This condition is saved as the Hold attribute status and checked in the HOLDING OPEN state. |
| Lock | ignore | There’s nothing to do at this point, but we assume the lock attribute will be set and we will check it later, so the event info is not lost. |
| Unlock | can't happen | Cabin is not able to progress to a state where it can send this event while we are opening the door. |

### CLOSED

| Event | Response | Explanation |
|---|---|---|
| Door opened | can't happen | The door is closed and cannot instantaneously be open. |
| Passenger close | ignore | The door is already closed, so just ignore. |
| Time to close | can't happen | This is a delayed event that is canceled on any path that enters the current state. |
| Hold released | ignore | This condition is saved as the Hold attribute status and checked in the HOLDING OPEN state. |
| Door closed | can't happen | The door is already closed. |
| Unlock | can't happen | Cabin can’t send an unlock before a lock, which would have put us in the LOCKED state. |
| Door blocked | can't happen | You can’t block a closed door. |

### LOCKED

| Event | Response | Explanation |
|---|---|---|
| Door opened | can't happen | The whole point of this state is to ensure the door is not opened. It cannot open while locked. |
| Passenger open | ignore | The door is not safe to open in this state so the request is ignored. |
| Passenger close | ignore | The door is already closed, so just ignore. |
| Time to close | can't happen | This is a delayed event that is canceled on any path that enters the current state. |
| Hold released | ignore | This condition is saved as the Hold attribute status and checked in the HOLDING OPEN state. |
| Door closed | can't happen | The door is already closed. |
| Lock | can't happen | The cabin is synched so that it won’t issue another lock request before unlocking. |
| Door blocked | can't happen | You can’t block a closed door. |

### CANNOT CLOSE

| Event | Response | Explanation |
|---|---|---|
| Door opened | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |
| Passenger open | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |
| Passenger close | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |
| Time to close | can't happen | This is a delayed event that is canceled on any path that enters the current state. |
| Hold released | ignore | This condition is saved as the Hold attribute status and checked in the HOLDING OPEN state. |
| Door closed | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |
| Lock | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |
| Unlock | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |
| Door blocked | can't happen | Presumably the shaft is out of service and no events will be issued until it is back in service again. |

