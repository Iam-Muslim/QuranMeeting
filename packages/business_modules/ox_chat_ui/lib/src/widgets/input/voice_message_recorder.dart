import 'package:flutter/material.dart';

class VoiceMessageRecorder extends StatelessWidget {
  final void Function(String path, Duration duration)? onSend;
  const VoiceMessageRecorder({super.key, this.onSend});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
