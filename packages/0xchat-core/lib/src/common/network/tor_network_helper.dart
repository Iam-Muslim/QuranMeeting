import 'dart:io';

/// Tor daemon support is disabled in this Nostr Meet build for low-latency WebRTC.
class TorNetworkHelper {
  static bool get isTorEnabled => false;
  static InternetAddress get torProxyHost => InternetAddress.loopbackIPv4;
  static int get torProxyPort => 0;

  static Future<void> initialize() async {}
  static Future<void> start() async {}
  static Future<void> stop() async {}
  static void updateCustomProxy(String host, int port) {}
  static void clearCustomProxy() {}
  static bool shouldUseTor(String url) => false;
}
