import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

enum PlatformStyle {
  cupertino,
  material,
  auto;

  bool get isIos {
    switch (this) {
      case cupertino:
        return true;
      case material:
        return false;
      default:
        if (kIsWeb) {
          return false;
        }
        return Platform.isIOS || Platform.isMacOS;
    }
  }
}
