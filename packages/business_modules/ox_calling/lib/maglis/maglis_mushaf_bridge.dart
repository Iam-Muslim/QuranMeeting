import 'package:flutter/foundation.dart';

/// Wire-compatible bridge types & hooks for Maglis inside Quran Meeting.
/// Swap with your full MushafProvider / recite_quran package when you add Mus'haf data.

enum ErrorCategory { speech, tajweed, other }

enum SpeechErrorType { substitution, omission, insertion, pronunciation, none }

enum TajweedDurationStatus { short, normal, long, missing, excessive }

class ReciterError {
  final ErrorCategory errorType;
  final SpeechErrorType speechErrorType;
  final TajweedDurationStatus? durationStatus;
  final String expectedPh;
  final String predictedPh;

  const ReciterError({
    this.errorType = ErrorCategory.speech,
    this.speechErrorType = SpeechErrorType.none,
    this.durationStatus,
    this.expectedPh = '',
    this.predictedPh = '',
  });
}

/// Canonical 32-bit compact coordinate packer matching Natlu wire format verbatim:
/// ((surah & 0xFF) << 20) | ((ayah & 0xFFF) << 8) | (word0 & 0xFF)
class QuranCoordinate {
  static int packWordKey(int surah, int ayah, int word0) =>
      ((surah & 0xFF) << 20) | ((ayah & 0xFFF) << 8) | (word0 & 0xFF);

  static (int surah, int ayah, int word0) unpackWordKey(int key) => (
        (key >> 20) & 0xFF,
        (key >> 8) & 0xFFF,
        key & 0xFF,
      );

  static int packAyahKey(int surah, int ayah) =>
      ((surah & 0xFFFF) << 16) | (ayah & 0xFFFF);

  static (int surah, int ayah) unpackAyahKey(int key) => (
        (key >> 16) & 0xFFFF,
        key & 0xFFFF,
      );
}

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  static bool Function() isMaglisSessionActive = () => false;

  int lastSurah = 1;
  int lastAyah = 1;
  int activePage = 1;
  String? lastBannerMessage;

  void enterMaglisSession(int page) {
    activePage = page;
    notifyListeners();
  }

  void exitMaglisSession() {
    notifyListeners();
  }

  void showMaglisPeerJoinedBanner() {
    lastBannerMessage = 'A participant joined the Quran Meeting room';
    notifyListeners();
  }

  void showMaglisPeerLeftBanner() {
    lastBannerMessage = 'A participant left the Quran Meeting room';
    notifyListeners();
  }
}

class MushafProvider {
  MushafProvider._();
  static final MushafProvider instance = MushafProvider._();

  /// Placeholder mapping until full Mus'haf page index data is added.
  int? getPageForAyah(int surah, int ayah) => 1;
}

class QuranMetadata {
  static int clampPage(int page) => page.clamp(1, 604);
  static int clampSurah(int surah) => surah.clamp(1, 114);
}

class QuranTypography {
  static String toWesternDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x0660 && rune <= 0x0669) {
        buffer.writeCharCode(0x30 + (rune - 0x0660));
      } else if (rune >= 0x06F0 && rune <= 0x06F9) {
        buffer.writeCharCode(0x30 + (rune - 0x06F0));
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  static String formatDigits(String input, {required bool isArabic}) {
    final western = toWesternDigits(input);
    if (!isArabic) return western;
    final buffer = StringBuffer();
    for (final rune in western.runes) {
      if (rune >= 0x30 && rune <= 0x39) {
        buffer.writeCharCode(0x0660 + (rune - 0x30));
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }
}
