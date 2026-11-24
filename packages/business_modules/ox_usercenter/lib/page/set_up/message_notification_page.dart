import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';

/// Push notification servers (FCM/UnifiedPush) are removed in this serverless Nostr Meet build.
class MessageNotificationPage extends StatelessWidget {
  const MessageNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(title: 'Notifications'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Push servers (FCM / UnifiedPush) are disabled in this serverless Nostr Meet build. '
            'Keep the app open or share room links directly to start meetings.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeColor.color100, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
