import 'dart:convert';
import 'dart:ui';

// import 'package:intl/intl.dart';
// import 'package:jiffy/jiffy.dart';

String? tStringOrNull(dynamic value, {bool allowEmpty = false}) {
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

  if (!allowEmpty && targetValue != null && targetValue.trim().isEmpty) {
    return null;
  }
  return targetValue;
}

String tString(
  dynamic value, {
  bool allowEmpty = true,
  String defaultValue = "",
}) {
  return tStringOrNull(value, allowEmpty: allowEmpty) ?? defaultValue;
}

bool tBool(
  dynamic value, {
  /// return true if greater than this number
  num numberThreshold = 0,

  /// return this number if not specified
  bool defaultValue = false,
}) {
  bool? targetValue;

  if (value is bool) {
    targetValue = value;
  } else if (value is String && value.isNotEmpty) {
    if (value.toLowerCase().replaceAll(" ", "") != "false") {
      targetValue = true;
    }
  } else if ((value is int || value is double)) {
    if (value > numberThreshold) {
      targetValue = true;
    }
  }
  return targetValue ?? defaultValue;
}

int? tIntOrNull(dynamic value) {
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

int tInt(dynamic value, {int defaultValue = 0}) {
  return tIntOrNull(value) ?? defaultValue;
}

double? tDoubleOrNull(dynamic value) {
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

double tDouble(dynamic value, {double defaultValue = 0.0}) {
  return tDoubleOrNull(value) ?? defaultValue;
}

Map<String, Object> tMap(val) {
  return val is Map<String, Object> ? val : {};
}

String takeLast(String? value, int count) {
  if (value == null || value.isEmpty || count < 1) return "";
  if (value.length > count) {
    return value.substring(value.length - count);
  } else {
    return value;
  }
}

String takeFirst(String? value, int count) {
  if (value == null || value.isEmpty || count < 1) return "";
  if (value.length > count) {
    return value.substring(0, count);
  } else {
    return value;
  }
}

dynamic shortenParamForLog(dynamic value, {int keep = 1000}) {
  if (value is String) {
    if (value.length > keep) {
      return value.substring(0, keep - 1);
    }
  }
  return value;
}

bool isDark(Color color, {double threshold = 0.15}) {
  final double relativeLuminance = color.computeLuminance();
  return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) <= threshold);
}

Color contrastColor(Color color, {double threshold = 0.15}) {
  return isDark(color, threshold: threshold)
      ? const Color(0xffffffff)
      : const Color(0xff000000);
}

Color contrastColorTrans(
  Color color, {
  double blackOpacity = 0.12,
  double whiteOpacity = 0.24,
  double threshold = 0.15,
}) {
  return isDark(color, threshold: threshold)
      ? const Color(0xffffffff).withOpacity(whiteOpacity)
      : const Color(0xff000000).withOpacity(blackOpacity);
}

String encodeQueryParameters(Map<String, String> params) {
  try {
    return params.entries
        .map((e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}")
        .join("&");
  } catch (e) {
    return "";
  }
}

String? toPrettyJson(dynamic json) {
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

String toPrice(
  dynamic cents, {
  bool showPlus = false,
  bool isNegative = false,
  String? symbol = "\$",
  int decimalDigits = 2,

  /// 1 if is dollar, 100 if is cent
  double divider = 100,
  bool removeTrailingZeros = false,
}) {
  if (cents != null) {
    dynamic val = cents;
    if (cents is String) {
      val = double.tryParse(cents);
    }
    if (val is num) {
      final bool trueNegative = isNegative || (val < 0);
      String dollarResult = (divider > 1 ? (val / divider) : val)
          .abs()
          .toDouble()
          .toStringAsFixed(decimalDigits);
      List<String> dollarParts = dollarResult.split('.');
      dollarParts[0] = dollarParts[0].replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
      dollarResult = dollarParts.join('.');

      if (removeTrailingZeros) {
        dollarResult = dollarResult.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      }

      if (symbol?.isNotEmpty ?? false) {
        dollarResult = "$symbol$dollarResult";
      }

      if (trueNegative) {
        dollarResult = "-$dollarResult";
      } else if (showPlus) {
        dollarResult = "+$dollarResult";
      }

      // String result = NumberFormat.currency(
      //   symbol: symbol,
      //   decimalDigits: decimalDigits,
      // ).format(val / 100);
      // if (isNegative && val > 0) {
      //   result = "-$result";
      // } else if (showPlus && val >= 0) {
      //   result = "+$result";
      // }
      // if (removeTrailingZeros) {
      //   if (result == '0') return '0';
      //   if (result.endsWith('.00')) {
      //     return result.substring(0, result.length - 3);
      //   }
      //   if (result.endsWith('0')) return result.substring(0, result.length - 1);
      // }
      return dollarResult;
    }
  }
  return "\$-";
}

String tUrl(val) {
  final String str = tString(val);
  if (str.toLowerCase().startsWith('http')) {
    return str;
  }
  return "";
}

String? tUrlOrNull(val) {
  final String str = tString(val);
  if (str.toLowerCase().startsWith('http')) {
    return str;
  }
  return null;
}

String _padZero(int value) {
  return value.toString().padLeft(2, '0');
}

String? tDateString(val) {
  DateTime? d;
  if (val is int || val is double) {
    final int intVal = val is int ? val : val.round();
    if (intVal < 100000000000) {
      d = DateTime.fromMillisecondsSinceEpoch(intVal * 1000);
    } else {
      d = DateTime.fromMillisecondsSinceEpoch(intVal);
    }
  } else if (val is String) {
    d = DateTime.parse(val);
  } else if (val is DateTime) {
    d = val;
  }

  if (d is DateTime) {
    final String year = d.year.toString();
    final String month = _padZero(d.month);
    final String day = _padZero(d.day);
    return '$year-$month-$day';
    // return DateFormat('yyyy-MM-dd').format(d);
  }

  return null;
}

List<T> tList<T>(val) {
  if (val is List) {
    return val.map((item) => item as T).toList();
  }

  if (val is String) {
    try {
      var decodedJSON = json.decode(val);
      if (decodedJSON is List) {
        return decodedJSON.map((item) => item as T).toList();
      }
    } catch (e) {}
  }

  return [];
}

List<T>? tListOrNull<T>(
  val, {
  bool allowEmpty = false,
}) {
  if (val is List<T> && val.isNotEmpty) {
    return val;
  }
  return null;
}

List<String> tListString(val) {
  return (val as List).map((item) => item as String).toList();
}

DateTime? tTime(
  dynamic val, {
  final bool toLocal = true,
}) {
  DateTime? result;
  if (val is DateTime) {
    result = val;
  } else if (val is int || val is double) {
    if (val < 100000000000) {
      result = DateTime.fromMillisecondsSinceEpoch(val * 1000);
    } else {
      result = DateTime.fromMillisecondsSinceEpoch(val);
    }
  } else if (val is String) {
    result = DateTime.parse(val);
  }

  if (toLocal) {
    return result?.toLocal();
  }
  return result;
}

int? tDaysFromNow(val) {
  final DateTime? targetTime = tTime(val);
  if (targetTime is DateTime) {
    final endOfTargetTimeDay = DateTime(targetTime.year, targetTime.month,
        targetTime.day, 23, 59, 59, 999, 999);
    return endOfTargetTimeDay.difference(DateTime.now()).inDays;
  }
  return null;
}

bool hasMatch(String? value, String pattern) {
  return (value == null) ? false : RegExp(pattern).hasMatch(value);
}

bool isURL(String s) => hasMatch(s,
    r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");
