import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_calling/maglis/maglis_controller.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';

/// Google Meet–style Quran Meeting Home & Room screen.
/// Designed for maximum simplicity for kids and elderly users.
class MaglisRoomPage extends StatefulWidget {
  const MaglisRoomPage({super.key});

  @override
  State<MaglisRoomPage> createState() => _MaglisRoomPageState();
}

class _MaglisRoomPageState extends State<MaglisRoomPage> {
  final MaglisController _maglis = MaglisController.instance;
  final TextEditingController _codeController = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _maglis.addListener(_refresh);
    _maglis.sessionListenable.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _maglis.removeListener(_refresh);
    _maglis.sessionListenable.removeListener(_refresh);
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    setState(() => _busy = true);
    try {
      final ok = await _maglis.startSession(isHost: true);
      if (!ok && mounted) {
        CommonToast.instance.show(context, 'Could not start meeting. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinRoom() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      CommonToast.instance.show(context, 'Please enter a room code');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      final res = await _maglis.verifyAndJoinRoom(code: code, page: 1, surah: 1, ayah: 1);
      if (mounted && !_maglis.inSession) {
        CommonToast.instance.show(context, 'Could not join room (${res.name})');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isNotEmpty) {
      setState(() {
        _codeController.text = text;
      });
    } else if (mounted) {
      CommonToast.instance.show(context, 'Nothing copied yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final inSession = _maglis.inSession;
    final userName = OXUserInfoManager.sharedInstance.currentUserInfo?.name?.trim() ?? '';
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: AppBar(
        backgroundColor: ThemeColor.color190,
        elevation: 0,
        title: Text(
          'Quran Meeting',
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (inSession)
            IconButton(
              icon: Icon(Icons.copy_rounded, color: ThemeColor.color0, size: 26),
              tooltip: 'Copy Room Code',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _maglis.roomCode));
                CommonToast.instance.show(context, 'Copied code: ${_maglis.roomCode}');
              },
            ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            if (!inSession) _buildMeetHome(userName) else _buildActiveRoomCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetHome(String userName) {
    final greeting = userName.isNotEmpty ? 'Assalamu Alaikum, $userName' : 'Assalamu Alaikum';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          greeting,
          style: TextStyle(
            color: ThemeColor.color100,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // 1. Primary Google Meet-style "New Meeting" Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.video_call_rounded, size: 28),
                  label: Text(
                    _busy ? 'Starting...' : 'New Meeting',
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  onPressed: _busy ? null : _createRoom,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Start a room and share the code with your family or teacher.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ThemeColor.color100, fontSize: 14, height: 1.35),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 2. Simple "Join with a Code" Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Join a Meeting',
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _codeController,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) {
                  if (!_busy) _joinRoom();
                },
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter room code',
                  hintStyle: TextStyle(color: ThemeColor.color120, fontSize: 17),
                  filled: true,
                  fillColor: ThemeColor.color190,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.content_paste_rounded, color: ThemeColor.color100, size: 24),
                    tooltip: 'Paste',
                    onPressed: _pasteCode,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.color170,
                    foregroundColor: ThemeColor.color0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.login_rounded, size: 24),
                  onPressed: _busy ? null : _joinRoom,
                  label: const Text(
                    'Join',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 3. Simple 1-2-3 guide for kids & older adults
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ThemeColor.color180.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _guideRow(Icons.looks_one_rounded, 'Tap "New Meeting" or type a room code'),
              const SizedBox(height: 10),
              _guideRow(Icons.looks_two_rounded, 'Share the short room code to invite others'),
              const SizedBox(height: 10),
              _guideRow(Icons.looks_3_rounded, 'Read and listen to Quran together'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _guideRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D9488), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: ThemeColor.color60,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveRoomCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Room: ${_maglis.roomCode}',
                style: TextStyle(color: ThemeColor.color0, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Chip(
                label: Text('${_maglis.participantCount} peers'),
                backgroundColor: const Color(0xFF0D9488),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ThemeColor.color190,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Mushaf Packet Sync (Ready for Mushaf UI)',
                  style: TextStyle(color: ThemeColor.color100, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  'Surah ${_maglis.remoteSurah} : Ayah ${_maglis.remoteAyah}'
                  '${_maglis.remoteWord != null ? ' : Word ${_maglis.remoteWord}' : ''}',
                  style: TextStyle(color: ThemeColor.color0, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _maglis.isMicMuted ? Colors.grey[700] : const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                ),
                icon: Icon(_maglis.isMicMuted ? Icons.mic_off : Icons.mic),
                label: Text(_maglis.isMicMuted ? 'Unmute' : 'Mute'),
                onPressed: _maglis.toggleMic,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.call_end),
                label: const Text('Leave'),
                onPressed: () => _maglis.leaveSession(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
