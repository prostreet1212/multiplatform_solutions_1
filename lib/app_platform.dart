import 'dart:io';
import 'package:flutter/foundation.dart';

class AppPlatform {
  static String getPlatform() {
    if (kIsWeb) {
      return 'web';
    }
    return Platform.operatingSystem;
  }

  static String get platform => getPlatform();
}
