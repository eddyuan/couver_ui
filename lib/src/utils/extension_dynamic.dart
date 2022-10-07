import 'couver_util.dart';

extension CouverDynamicExtension on dynamic {
  String? tStringOrNull() => CouverUtil.tStringOrNull(this);
  String tString([String defaultValue = ""]) =>
      CouverUtil.tString(this, defaultValue: defaultValue);

  bool tBool([num numberThreshhold = 0]) =>
      CouverUtil.tBool(this, numberThreshhold: numberThreshhold);

  int? tIntOrNull() => CouverUtil.tIntOrNull(this);
  int tInt([int defaultValue = 0]) =>
      CouverUtil.tInt(this, defaultValue: defaultValue);

  double? tDoubleOrNull() => CouverUtil.tDoubleOrNull(this);
  double tDouble() => CouverUtil.tDouble(this);
}
