import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/upload/file_type.dart';

/// File and image uploads are intentionally disabled in this Nostr Meet build.
class UploadUtils {
  static Future<UploadResult> uploadFile({
    BuildContext? context,
    required FileType fileType,
    required File file,
    required String filename,
    String? encryptedKey,
    String? encryptedNonce,
    bool showLoading = true,
    bool autoStoreImage = true,
    Function(double progress)? onProgress,
    Function(String serverName)? onServerSelected,
  }) async {
    return UploadResult.error('File and image uploads are disabled.');
  }
}

class UploadResult {
  final bool isSuccess;
  final String url;
  final String? errorMsg;
  final String? encryptedKey;
  final String? encryptedNonce;

  UploadResult({
    required this.isSuccess,
    required this.url,
    this.errorMsg,
    this.encryptedKey,
    this.encryptedNonce,
  });

  factory UploadResult.success(String url, String? encryptedKey, String? encryptedNonce) {
    return UploadResult(
      isSuccess: true,
      url: url,
      encryptedKey: encryptedKey,
      encryptedNonce: encryptedNonce,
    );
  }

  factory UploadResult.error(String errorMsg) {
    return UploadResult(isSuccess: false, url: '', errorMsg: errorMsg);
  }
}

class UploadExceptionHandler {
  static String getErrorMessage(dynamic e) => 'File uploads are disabled.';
  static UploadResult handleException(dynamic e) =>
      UploadResult.error(getErrorMessage(e));
}

class UploadProgress {
  final double progress;
  final String? serverName;

  const UploadProgress({this.progress = 0.0, this.serverName});
}

class UploadManager {
  static final UploadManager shared = UploadManager._internal();
  UploadManager._internal();

  Future<UploadResult> uploadFile({
    required FileType fileType,
    required String filePath,
    required String uploadId,
    String? receivePubkey,
    String? encryptedKey,
    String? encryptedNonce,
    bool autoStoreImage = true,
    Function(UploadResult result, bool isFromCache)? completeCallback,
  }) async {
    final res = UploadResult.error('File and image uploads are disabled.');
    completeCallback?.call(res, false);
    return res;
  }

  Stream<UploadProgress> getUploadProgress(String uploadId, String? receivePubkey) =>
      const Stream<UploadProgress>.empty();

  UploadResult? getUploadResult(String uploadId, String? receivePubkey) => null;

  void prepareUploadStream(String uploadId, String? receivePubkey) {}
}
