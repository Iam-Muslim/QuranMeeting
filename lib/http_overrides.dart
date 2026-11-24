import 'dart:io';
import 'package:ox_common/log_util.dart';

class OXHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      ..badCertificateCallback = badCertificateHandler;
    return client;
  }

  bool badCertificateHandler(X509Certificate cert, String host, int port) {
    LogUtil.e('[OXHttpOverrides] Rejecting bad certificate for $host:$port');
    return false;
  }
}
