# Phase 4: Google Meet Room UI & Optional Mushaf Slot

## Goal
Redesign the active-meeting state of `MaglisRoomPage` into a clean, kid- and elder-friendly **Google Meet–style** room with an optional, toggleable **Mushaf** view.

## Tasks
1. **Adaptive Video / Avatar Grid**
   - Show large, clear tiles for each participant (live video when camera is on; large avatar + name + speaking indicator when camera is off).
   - Keep the room code + **Copy / Share** button prominent at the top.

2. **Simple Bottom Control Bar**
   - Large, clearly labeled buttons:
     - **Mic** (Mute / Unmute)
     - **Camera** (On / Off)
     - **Mushaf** (Optional toggle — opens/closes the Mushaf panel)
     - **Chat** (Opens in-meeting text chat drawer)
     - **People** (Participant list with one-tap **Add Friend** using `pubkey`)
     - **Leave** (Red end-call button)

3. **Optional Mushaf Integration Hook**
   - Provide a `WidgetBuilder? mushafViewBuilder` slot wired to `MaglisController.onSyncMushafUI` and `onRemoteRecitationProgress` so your Mushaf UI drops in cleanly when ready.
