import 'dart:io' show Platform;

enum PlatformStyle { cupertino, material, auto }

extension PlatformStyleExtension on PlatformStyle {
  bool get isIos {
    switch (this) {
      case PlatformStyle.cupertino:
        return true;
      case PlatformStyle.material:
        return false;
      default:
        return Platform.isIOS || Platform.isMacOS;
    }
  }
}
