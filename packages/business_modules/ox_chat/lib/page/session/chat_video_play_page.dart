import 'package:flutter/material.dart';

/// Video file playback is disabled in this text-only Nostr Meet build.
class ChatVideoPlayPage extends StatelessWidget {
  final String videoUrl;
  final String? videoPath;
  const ChatVideoPlayPage({super.key, this.videoUrl = '', this.videoPath});

  static void show(BuildContext context, {String videoUrl = '', String? videoPath}) {}

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('Video attachments are disabled in Nostr Meet.')),
      );
}
