extension CouverStringExtension on String {
  bool isSimilar(String value) {
    return replaceAll(" ", "").toLowerCase() ==
        value.replaceAll(" ", "").toLowerCase();
  }

  String toSingleSpaceOnly() => replaceAll(RegExp(r"\s+"), " ").trim();
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : "";

  String toTitleCase() => replaceAll(RegExp(" +"), " ")
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");

  String toMaskedCardNumber({
    String obscureText = "•",
    int targetLength = 16,
    int seperatedBy = 4,
    bool substringFromEnd = true,
  }) {
    String targetVal = replaceAll(" ", "");
    if (targetVal.length < targetLength) {
      targetVal =
          List.generate(targetLength - targetVal.length, (index) => obscureText)
                  .join() +
              targetVal;
    } else if (targetVal.length > targetLength) {
      if (substringFromEnd) {
        targetVal = targetVal.substring(targetVal.length - targetLength);
      } else {
        targetVal = targetVal.substring(0, targetLength);
      }
    }
    String result = "";
    if (seperatedBy > 0) {
      for (int i = 0; i < targetVal.length; i++) {
        result +=
            (i > 0 && i % seperatedBy == 0) ? " ${targetVal[i]}" : targetVal[i];
      }
    } else {
      result = targetVal;
    }
    return result;
  }

  String toObscuredEmail({String obscureText = "*"}) {
    if (contains("@")) {
      final splited = replaceAll(" ", "").split("@");
      final String first = splited.first.length > 3
          ? splited.first.substring(0, 3)
          : splited.first;
      final String last = splited.last.length > 5
          ? splited.last.substring(splited.last.length - 5, splited.last.length)
          : splited.last;
      return '$first$obscureText@$obscureText$last';
    }
    return this;
  }

  String lastChars(int n) {
    if (n <= 0) return "";
    if (n >= length) return this;
    return substring(length - n);
  }

  String firstChars(int n) {
    if (n <= 0) return "";
    if (n >= length) return this;
    return substring(0, n + 1);
  }
}
