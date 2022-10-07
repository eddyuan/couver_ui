import "package:flutter/material.dart";

enum BtnSize { mini, xs, sm, df, md, lg, xl, manageCard, cashback }

enum BtnTextSize { mini, xs, sm, df, md, lg, xl, manageCard, cashback }

extension BtnSizeExtension on BtnSize {
  EdgeInsetsGeometry get padding {
    switch (this) {
      case BtnSize.xl:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case BtnSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case BtnSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case BtnSize.sm:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 6);
      case BtnSize.xs:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case BtnSize.mini:
        return const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
      case BtnSize.manageCard:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case BtnSize.cashback:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      default:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
    }
  }

  double get value {
    switch (this) {
      case BtnSize.xl:
        return 56;
      case BtnSize.lg:
        return 48;
      case BtnSize.md:
        return 44;
      case BtnSize.sm:
        return 32;
      case BtnSize.xs:
        return 28;
      case BtnSize.mini:
        return 20;
      case BtnSize.manageCard:
        return 20;
      case BtnSize.cashback:
        return 32;
      default:
        return 38;
    }
  }

  double get textSize {
    switch (this) {
      case BtnSize.xl:
        return BtnTextSize.xl.value;
      case BtnSize.lg:
        return BtnTextSize.lg.value;
      case BtnSize.md:
        return BtnTextSize.md.value;
      case BtnSize.sm:
        return BtnTextSize.sm.value;
      case BtnSize.xs:
        return BtnTextSize.xs.value;
      case BtnSize.mini:
        return BtnTextSize.mini.value;
      case BtnSize.manageCard:
        return BtnTextSize.manageCard.value;
      case BtnSize.cashback:
        return BtnTextSize.cashback.value;
      default:
        return BtnTextSize.df.value;
    }
  }

  FontWeight get fontWeight {
    switch (this) {
      case BtnSize.manageCard:
        return FontWeight.normal;
      case BtnSize.cashback:
        return FontWeight.normal;
      default:
        return FontWeight.w500;
    }
  }
}

extension BtnTextSizeExtension on BtnTextSize {
  double get value {
    switch (this) {
      case BtnTextSize.xl:
        return 18;
      case BtnTextSize.lg:
        return 16;
      case BtnTextSize.md:
        return 16;
      case BtnTextSize.sm:
        return 14;
      case BtnTextSize.xs:
        return 13;
      case BtnTextSize.mini:
        return 13;
      case BtnTextSize.manageCard:
        return 10;
      case BtnTextSize.cashback:
        return 12;
      default:
        return 16;
    }
  }
}
