# Phase 3: Maglis Video, Participant Identity & In-Meeting Chat

## Goal
Upgrade the `ox_calling/lib/maglis` WebRTC engine from audio-only + anonymous peer IDs to full **Video + Audio + Identity + In-Meeting Text Chat**.

## Tasks
1. **Optional Camera Video (`MaglisMediaHelper` & `MaglisPeerSession`)**
   - Add `buildMediaConstraints({bool audio = true, bool video = false, bool frontCamera = true})` in `maglis_media_helper.dart`.
   - Support `toggleCamera()`, `switchCamera()`, and mid-call track renegotiation in `MaglisPeerSession` and `MaglisController`.
   - Expose local `RTCVideoRenderer` and per-peer remote `RTCVideoRenderer`s.

2. **Participant Identity (For "Add Friend")**
   - Attach the user's Nostr `pubkey`, `name`, and `picture` to the Maglis join/beacon payload in `MaglisNetworkEngine` / `MaglisCore`.
   - Expose a `List<MaglisParticipantInfo>` on `MaglisController` so the room UI knows each participant's name, avatar, and `pubkey`.

3. **In-Meeting Text Chat**
   - Add a `chatMessage` packet type to `MaglisPacket` over the existing SCTP DataChannel for instant, zero-server in-meeting messages.
   - Expose `Stream<MaglisChatMessage>` / `List<MaglisChatMessage>` and `sendChatMessage(String text)` on `MaglisController`.
