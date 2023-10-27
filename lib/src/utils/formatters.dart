import "package:flutter/services.dart";
// import 'package:intl/intl.dart';
import "package:mask_text_input_formatter/mask_text_input_formatter.dart";

class CFormatters {
  static final FilteringTextInputFormatter nameFormatter =
      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"));

  static final FilteringTextInputFormatter amountFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^\d{1,6}(\.\d{0,2})?"));

  static final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
      mask: "(###)###-####", filter: {"#": RegExp(r"[0-9]")});

  static final FilteringTextInputFormatter addressFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9&%=-_]+$"));

  static final MaskTextInputFormatter cardNumFormatter = MaskTextInputFormatter(
      mask: "#### #### #### ####", filter: {"#": RegExp(r"[0-9]")});

  static final MaskTextInputFormatter unionpayCardNumFormatter =
      MaskTextInputFormatter(
          mask: "#### #### #### #### ###", filter: {"#": RegExp(r"[0-9]")});

  static final MaskTextInputFormatter cardCvcFormatter =
      MaskTextInputFormatter(mask: "###", filter: {"#": RegExp(r"[0-9]")});

  static final MaskTextInputFormatter uniCardCvcFormatter =
      MaskTextInputFormatter(mask: "####", filter: {"#": RegExp(r"[0-9]")});

  static final MaskTextInputFormatter cardPinFormatter =
      MaskTextInputFormatter(mask: "######", filter: {"#": RegExp(r"[0-9]")});

  static final MaskTextInputFormatter cardDateFormatter =
      MaskTextInputFormatter(mask: "a#/##", filter: {
    "a": RegExp(r"[0-1]"),
    "#": RegExp(r"[0-9]"),
  });

  static FilteringTextInputFormatter emtAnswer =
      FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z_]"));
  static FilteringTextInputFormatter emtQuestion =
      FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z?!;\-., ]"));

  static FilteringTextInputFormatter numbersLetters =
      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"));

  static FilteringTextInputFormatter numbersLettersSpace =
      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]"));
  static FilteringTextInputFormatter noSpace =
      FilteringTextInputFormatter.deny(" ");
  // FilteringTextInputFormatter(filterPattern, allow: allow)
}
