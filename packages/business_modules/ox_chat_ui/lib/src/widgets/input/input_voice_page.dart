import 'package:flutter/material.dart';

class InputVoicePage extends StatelessWidget {
  final void Function(String path, Duration duration)? onPressed;
  final VoidCallback? onCancel;
  const InputVoicePage({super.key, this.onPressed, this.onCancel});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
