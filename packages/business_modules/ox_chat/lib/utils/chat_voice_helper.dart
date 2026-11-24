import 'dart:io';

/// Voice messages are disabled in this text-only Nostr Meet build.
class ChatVoiceMessageHelper {
  static Future<Duration?> getAudioDuration(String uri) async => null;
  static Future<(File?, Duration?)> populateMessageWithAudioDetails({
    required dynamic session,
    required dynamic message,
  }) async => (null, null);
}
