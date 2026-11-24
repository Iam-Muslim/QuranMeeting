# Phase 5: Friends, Groups & Meeting Invites

## Goal
Connect the **Chats** and **Friends & Groups** (`ox_chat`) seamlessly to **Quran Meeting** rooms.

## Tasks
1. **One-Tap "Start Meeting" from Any Chat or Group**
   - Add a **Start Meeting** button in 1-to-1 and Group chat headers (`ChatMessagePage`, `ChatGroupMessagePage`, `ChatRelayGroupMsgPage`).
   - Tapping it creates a Maglis room and sends a clickable **Join Quran Meeting** invite card into the chat.

2. **One-Tap "Add Friend" from Meeting**
   - In the meeting **People** sheet, allow tapping **Add Friend** next to any participant to add their Nostr `pubkey` via `Contacts.sharedInstance.addToContact(...)` for future meetings and chats.

3. **Keep Chats & Groups Simple**
   - Ensure group creation and friend adding use large, clear labels suitable for kids and older adults.
