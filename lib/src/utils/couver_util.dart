import 'dart:convert';
import 'dart:ui' show Color;

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class CouverUtil {
  // Converters--------------------------------------------------
  /// Convert anything to string
  static String? tStringOrNull(dynamic value) {
    String? targetValue;
    try {
      if (value == null) {
        targetValue = null;
      } else if (value is String) {
        targetValue = value;
      } else if (value is Map || value is List) {
        targetValue = jsonEncode(value);
      } else if (value is int || value is double) {
        return value.toString();
      } else if (value is bool) {
        targetValue = value.toString();
      } else {
        targetValue = value.toString();
      }
    } catch (e) {
      targetValue = null;
    }
    if (targetValue?.isEmpty ?? true) {
      return null;
    }
    return targetValue;
  }

  static String tString(dynamic value, {String defaultValue = ""}) {
    return tStringOrNull(value) ?? defaultValue;
  }

  static bool tBool(
    dynamic value, {

    /// return true if greater than this number
    num numberThreshhold = 0,
  }) {
    bool? targetValue;

    if (value is bool) {
      targetValue = value;
    } else if (value is String && value.isNotEmpty) {
      if (value.toLowerCase().replaceAll(" ", "") != "false") {
        targetValue = true;
      }
    } else if ((value is int || value is double)) {
      if (value > numberThreshhold) {
        targetValue = true;
      }
    }
    return targetValue ?? false;
  }

  static int? tIntOrNull(dynamic value) {
    int? targetValue;
    if (value is int) {
      targetValue = value;
    } else if (value is double) {
      targetValue = value.round();
    } else if (value is String && value.isNotEmpty) {
      targetValue = int.tryParse(value);
    }
    return targetValue;
  }

  static int tInt(dynamic value, {int defaultValue = 0}) {
    return tIntOrNull(value) ?? defaultValue;
  }

  static double? tDoubleOrNull(dynamic value) {
    double? targetValue;
    if (value is double) {
      targetValue = value;
    } else if (value is int) {
      targetValue = value.toDouble();
    } else if (value is String) {
      targetValue = double.tryParse(value);
    }
    return targetValue;
  }

  static double tDouble(dynamic value, {double defaultValue = 0.0}) {
    return tDoubleOrNull(value) ?? defaultValue;
  }

  static Map<String, Object> tMap(val) {
    return val is Map<String, Object> ? val : {};
  }

  static String takeLast(String? value, int count) {
    if (value == null || value.isEmpty || count < 1) return "";
    if (value.length > count) {
      return value.substring(value.length - count);
    } else {
      return value;
    }
  }

  static dynamic shortenParamForLog(dynamic value, {int keep = 1000}) {
    if (value is String) {
      if (value.length > keep) {
        return value.substring(0, keep - 1);
      }
    }
    return value;
  }

  static bool isDark(Color color, {double threshold = 0.15}) {
    final double relativeLuminance = color.computeLuminance();
    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) <=
        threshold);
  }

  static Color contrastColor(Color color, {double threshold = 0.15}) {
    return isDark(color, threshold: threshold)
        ? const Color(0xffffffff)
        : const Color(0xff000000);
  }

  static Color contrastColorTrans(
    Color color, {
    double blackOpacity = 0.12,
    double whiteOpacity = 0.24,
    double threshold = 0.15,
  }) {
    return isDark(color, threshold: threshold)
        ? const Color(0xffffffff).withOpacity(whiteOpacity)
        : const Color(0xff000000).withOpacity(blackOpacity);
  }

  static String encodeQueryParameters(Map<String, String> params) {
    try {
      return params.entries
          .map((e) =>
              "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}")
          .join("&");
    } catch (e) {
      return "";
    }
  }

  static String? toPrettyJson(dynamic json) {
    try {
      dynamic result = jsonDecode(json);
      return result;
    } catch (e) {
      if (json is Map) {
        return const JsonEncoder.withIndent("  ").convert(json);
      }
      if (json is String) {
        return json;
      }
      if (json != null) {
        return json.toString();
      }
    }

    return null;
  }

  static String toPrice(
    dynamic cents, {
    bool showPlus = false,
    bool isNegative = false,
    String? symbol = "\$",
    int decimalDigits = 2,

    /// 1 if is dollar, 100 if is cent
    double divider = 100,
  }) {
    if (cents != null) {
      dynamic val = cents;
      if (cents is String) {
        val = double.tryParse(cents);
      }
      if (val is int || val is double) {
        String result = NumberFormat.currency(
          symbol: symbol,
          decimalDigits: decimalDigits,
        ).format(val / 100);
        if (isNegative && val > 0) {
          result = "-$result";
        } else if (showPlus && val >= 0) {
          result = "+$result";
        }
        return result;
      }
    }
    return "\$-";
  }

  static String tUrl(val) {
    final String str = tString(val);
    return isURL(str) ? str : "";
  }

  static String? tDateString(val) {
    if (val is int) {
      return Jiffy(DateTime.fromMillisecondsSinceEpoch(val * 1000))
          .format("yyyy-MM-dd");
    }

    if (val is String || val is DateTime) {
      return Jiffy(val).format("yyyy-MM-dd");
    }

    return null;
  }

  static List<T> tList<T>(val) {
    if (val is List) {
      return val.map((item) => item as T).toList();
    }

    return [];
  }

  static List<String> tListString(val) {
    return (val as List).map((item) => item as String).toList();
  }

  static DateTime? tTime(dynamic val) {
    if (val is int) {
      if (val < 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(val);
      }
    }
    if (val is DateTime) {
      return val;
    }
    if (val is String) {
      return Jiffy(val).dateTime;
    }
    return null;
  }

  static int? tDaysFromNow(val) {
    final DateTime? targetTime = tTime(val);
    if (targetTime is DateTime) {
      return Jiffy(targetTime)
          .endOf(Units.DAY)
          .dateTime
          .difference(DateTime.now())
          .inDays;
    }
    return null;
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static bool isURL(String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");
}
