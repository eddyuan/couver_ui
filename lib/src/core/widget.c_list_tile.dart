// import 'package:couver_app/utils/helpers.dart';
// import 'package:couver_app/widgets/widgets.dart';
import 'package:couver_ui/src/core/widget.c_radio_icon.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'widget.c_ink.dart';

class CListTileSkeletonOption {
  const CListTileSkeletonOption({
    this.titleWidth = 0.4,
    this.subtitleWidth = 0.6,
    this.avatarSize = const Size(36, 36),
    this.showAvatar = true,
    this.showTitle = true,
    this.showContent = true,
    this.avatarBorderRadius,
    this.avatarBoxShape = BoxShape.circle,
  });
  final double titleWidth;
  final double subtitleWidth;
  final Size avatarSize;
  final bool showTitle;
  final bool showContent;
  final bool showAvatar;
  final BorderRadiusGeometry? avatarBorderRadius;
  final BoxShape avatarBoxShape;
}

class CListTile extends StatelessWidget {
  const CListTile({
    Key? key,
    // original
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.style,
    this.selectedColor,
    this.leadingIconColor,
    this.trailingIconColor,
    this.textColor,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minLeadingWidth,
    // end original
    this.leadingIcon,
    this.leadingIconSize,
    this.titleText,
    this.titleTextStyle,
    this.subtitleText,
    this.subtitleTextStyle,
    this.arrow = false,
    this.titleBold = false,
    this.gradient,
    this.titleColor,
    this.reserveLeadingSpace = false,
    // this.launchUrl,
    // this.fallbackCopyText,
    this.loading = false,
    this.loadingWidth,
    this.minHeight,
    this.dividerBottom = false,
    this.dividerTop = false,
    this.dividerThickness = 0.5,
    this.dividerInsets = true,
    this.skeletonOption = const CListTileSkeletonOption(),
    this.skeleton = false,
    this.rowAlignment = CrossAxisAlignment.center,
  })  : isRadio = false,
        radioSize = 20,
        radioInactiveColor = null,
        super(key: key);

  const CListTile.radio({
    Key? key,
    // Radio specific options
    this.radioSize = 20,
    this.radioInactiveColor,
    Color? radioColor,
    // original
    this.leading,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.style,
    this.selectedColor,
    this.leadingIconColor,
    this.textColor,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minLeadingWidth,
    // end original
    this.leadingIcon,
    this.leadingIconSize,
    this.titleText,
    this.titleTextStyle,
    this.subtitleText,
    this.subtitleTextStyle,
    this.titleBold = false,
    this.gradient,
    this.titleColor,
    this.reserveLeadingSpace = false,
    // this.launchUrl,
    // this.fallbackCopyText,
    this.loading = false,
    this.loadingWidth,
    this.minHeight,
    this.dividerBottom = false,
    this.dividerTop = false,
    this.dividerThickness = 0.5,
    this.dividerInsets = true,
    this.skeletonOption = const CListTileSkeletonOption(),
    this.skeleton = false,
    this.rowAlignment = CrossAxisAlignment.center,
  })  : isRadio = true,
        trailing = null,
        trailingIconColor = radioColor,
        arrow = false,
        super(key: key);

  //----------------Original datas---------------------
  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar]
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text]
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text]
  ///
  /// If [isThreeLine] is false, this should not wrap.
  ///
  /// If [isThreeLine] is true, this should be configured to take a maximum of
  /// two lines. For example, you can use [Text.maxLines] to enforce the number
  /// of lines.
  ///
  /// The subtitle's default [TextStyle] depends on [TextTheme.bodyText2] except
  /// [TextStyle.color]. The [TextStyle.color] depends on the value of [enabled]
  /// and [selected].
  ///
  /// When [enabled] is false, the text color is set to [ThemeData.disabledColor].
  ///
  /// When [selected] is false, the text color is set to [ListTileTheme.textColor]
  /// if it's not null and to [TextTheme.caption]'s color if [ListTileTheme.textColor]
  /// is null.
  final Widget? subtitle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon]
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget? trailing;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If true, then [subtitle] must be non-null (since it is expected to give
  /// the second and third lines of text).
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  ///
  /// When using a [Text] widget for [title] and [subtitle], you can enforce
  /// line limits using [Text.maxLines].
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  ///
  /// If this property is null then its value is based on [ListTileTheme.dense].
  ///
  /// Dense list tiles default to a smaller height.
  final bool? dense;

  /// Defines the color used for icons and text when the list tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.selectedColor]
  /// is used. If that is also null then [ColorScheme.primary] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final Color? selectedColor;

  /// Defines the default color for [leading] and [trailing] icons.
  ///
  /// If this property is null then [ListTileThemeData.iconColor] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final Color? leadingIconColor;
  final Color? trailingIconColor;

  /// Defines the default color for the [title] and [subtitle].
  ///
  /// If this property is null then [ListTileThemeData.textColor] is used. If that
  /// is also null then [ColorScheme.primary] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final Color? textColor;

  /// Defines the font used for the [title].
  ///
  /// If this property is null then [ListTileThemeData.style] is used. If that
  /// is also null then [ListTileStyle.list] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final ListTileStyle? style;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] and [onLongPress] callbacks are
  /// inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback? onLongPress;

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  ///
  /// By default the selected color is the theme's primary color. The selected color
  /// can be overridden with a [ListTileTheme].
  ///
  /// {@tool dartpad}
  /// Here is an example of using a [StatefulWidget] to keep track of the
  /// selected index, and using that to set the `selected` property on the
  /// corresponding [ListTile].
  ///
  /// ** See code in examples/api/lib/material/list_tile/list_tile.selected.0.dart **
  /// {@end-tool}
  final bool selected;

  /// {@template flutter.material.ListTile.tileColor}
  /// Defines the background color of `ListTile` when [selected] is false.
  ///
  /// When the value is null, the `tileColor` is set to [ListTileTheme.tileColor]
  /// if it's not null and to [Colors.transparent] if it's null.
  /// {@endtemplate}
  final Color? tileColor;

  /// Defines the background color of `ListTile` when [selected] is true.
  ///
  /// When the value if null, the `selectedTileColor` is set to [ListTileTheme.selectedTileColor]
  /// if it's not null and to [Colors.transparent] if it's null.
  final Color? selectedTileColor;

  /// {@template flutter.material.ListTile.enableFeedback}
  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// When null, the default value is true.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// The horizontal gap between the titles and the leading/trailing widgets.
  ///
  /// If null, then the value of [ListTileTheme.horizontalTitleGap] is used. If
  /// that is also null, then a default value of 16 is used.
  final double? horizontalTitleGap;

  /// The minimum width allocated for the [ListTile.leading]
  ///
  /// If null, then the value of [ListTileTheme.minLeadingWidth] is used. If
  /// that is also null, then a default value of 40 is used.
  final double? minLeadingWidth;

  // End of original data---------------------

  /// Quicker way to add a leading icon
  final IconData? leadingIcon;

  /// Quicker way to add text
  final String? titleText;

  /// Quicker way to adjust the quicker leading icon
  final double? leadingIconSize;

  /// Quicker way to add text
  final String? subtitleText;

  /// The style for subtitleText
  final TextStyle? titleTextStyle;

  /// The style for subtitleText
  final TextStyle? subtitleTextStyle;

  /// Show an arrow at the end
  final bool arrow;

  /// Give title a bold style
  final bool titleBold;

  /// Make the text color gradient
  final Gradient? gradient;

  /// The Color of the title text
  final Color? titleColor;

  /// Add a 24pt space when there's no leading
  final bool reserveLeadingSpace;

  // /// This will lead to url when tapped
  // /// It will fallback to copy [fallbackCopyText] or [titleText]
  // final String? launchUrl;

  // /// The text to copy if the url can not be launched
  // final String? fallbackCopyText;

  /// show a loading icon to override the trailing and disable the field
  final bool loading;

  /// width of the loading area
  final double? loadingWidth;

  /// The min height of the tile
  final double? minHeight;

  /// Add a divider at bottom
  final bool dividerBottom;

  /// Add a divider at top
  final bool dividerTop;

  /// Defined the thickness of the divider
  final double dividerThickness;

  /// Add side padding to the divider
  final bool dividerInsets;

  final CListTileSkeletonOption skeletonOption;

  final bool skeleton;

  final CrossAxisAlignment rowAlignment;

  // Radio related options ==================================
  final bool isRadio;

  /// Size of the radio icon
  final double radioSize;

  /// Color of the radio icon, default to theme disabled color
  final Color? radioInactiveColor;

  // End Radio related options ==================================

  bool get _enabled => enabled && !loading && !skeleton;

  // =====================================================================

  Widget? _gradientShader({Widget? child}) {
    final Gradient? gradient_ = gradient;
    if (gradient_ != null) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => gradient_.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: child,
      );
    }
    return child;
  }

  Color? _leadingIconColor(ThemeData theme, ListTileThemeData tileTheme) {
    if (!_enabled) return theme.disabledColor;

    if (selected) {
      return selectedColor ??
          tileTheme.selectedColor ??
          theme.listTileTheme.selectedColor ??
          theme.colorScheme.primary;
    }

    final Color? color = leadingIconColor ??
        tileTheme.iconColor ??
        theme.listTileTheme.iconColor;
    return color ?? theme.colorScheme.onSurface;
  }

  Color? _trailingIconColor(ThemeData theme, ListTileThemeData tileTheme) {
    if (!_enabled) return theme.disabledColor;

    if (selected) {
      return selectedColor ??
          tileTheme.selectedColor ??
          theme.listTileTheme.selectedColor ??
          theme.colorScheme.primary;
    }

    final Color? color = trailingIconColor ??
        tileTheme.iconColor ??
        theme.listTileTheme.iconColor;
    return color ?? theme.disabledColor;
  }

  Color? _textColor(
      ThemeData theme, ListTileThemeData tileTheme, Color? defaultColor) {
    if (!_enabled) return theme.disabledColor;

    if (selected) {
      return selectedColor ??
          tileTheme.selectedColor ??
          theme.listTileTheme.selectedColor ??
          theme.colorScheme.primary;
    }

    return textColor ??
        tileTheme.textColor ??
        theme.listTileTheme.textColor ??
        defaultColor;
  }

  bool _isDenseLayout(ThemeData theme, ListTileThemeData tileTheme) {
    return dense ?? tileTheme.dense ?? theme.listTileTheme.dense ?? false;
  }

  TextStyle _titleTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    if (titleTextStyle != null) {
      return titleTextStyle!;
    }
    final TextStyle textStyle;
    switch (style ??
        tileTheme.style ??
        theme.listTileTheme.style ??
        ListTileStyle.list) {
      case ListTileStyle.drawer:
        textStyle = theme.textTheme.bodyLarge!;
        break;
      case ListTileStyle.list:
        textStyle = theme.textTheme.titleMedium!;
        break;
    }
    final Color? color = _textColor(theme, tileTheme, textStyle.color);
    return textStyle.copyWith(
      color: color,
      fontWeight: titleBold ? FontWeight.w600 : null,
      fontSize: _isDenseLayout(theme, tileTheme) ? 14.0 : 16.0,
    );
  }

  TextStyle _subtitleTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final Color? color =
        _textColor(theme, tileTheme, theme.textTheme.bodySmall!.color);
    return textStyle.copyWith(
      color: color,
      fontSize: _isDenseLayout(theme, tileTheme) ? 12.0 : 13.0,
    );
  }

  TextStyle _leadingTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final Color? color = _textColor(theme, tileTheme, textStyle.color);
    return textStyle.copyWith(color: color);
  }

  TextStyle _trailingTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final Color? color =
        _textColor(theme, tileTheme, theme.textTheme.bodySmall!.color);
    return textStyle.copyWith(color: color);
  }

  Color _tileBackgroundColor(ThemeData theme, ListTileThemeData tileTheme) {
    final Color? color = selected
        ? selectedTileColor ??
            tileTheme.selectedTileColor ??
            theme.listTileTheme.selectedTileColor
        : tileColor ?? tileTheme.tileColor ?? theme.listTileTheme.tileColor;
    return color ?? Colors.transparent;
  }

  final Duration _kAnimationSizeDuration = const Duration(milliseconds: 200);
  final double _kDefaultPadding = 24;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ListTileThemeData tileTheme = Theme.of(context).listTileTheme;
    final double minHeight_ = minHeight ?? ((dense ?? false) ? 42 : 56);

    final double horizontalTitleGap_ =
        horizontalTitleGap ?? tileTheme.horizontalTitleGap ?? 16;

    final Color tileBackgroundColorVal_ =
        _tileBackgroundColor(theme, tileTheme);

    final bool dense_ = _isDenseLayout(theme, tileTheme);

    Widget? innerRow_;
    if (skeleton) {
      final Color skeletonBaseColor_ =
          tileBackgroundColorVal_ == Colors.transparent
              ? Theme.of(context).cardColor
              : tileBackgroundColorVal_;
      innerRow_ = Shimmer.fromColors(
        baseColor: theme.disabledColor.withOpacity(0.1),
        highlightColor: skeletonBaseColor_.withOpacity(0.1),
        child: Row(
          crossAxisAlignment: rowAlignment,
          children: [
            if (skeletonOption.showAvatar)
              Padding(
                padding: EdgeInsets.only(right: horizontalTitleGap_),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth:
                          minLeadingWidth ?? tileTheme.minLeadingWidth ?? 24),
                  child: Center(
                    child: Container(
                      width: skeletonOption.avatarSize.width,
                      height: skeletonOption.avatarSize.height,
                      decoration: BoxDecoration(
                        color: skeletonBaseColor_,
                        shape: skeletonOption.avatarBoxShape,
                        borderRadius: skeletonOption.avatarBorderRadius,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight_),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (skeletonOption.showTitle)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: FractionallySizedBox(
                            widthFactor: skeletonOption.titleWidth,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: dense_ ? 14.0 : 16.0,
                              color: skeletonBaseColor_,
                            ),
                          ),
                        ),
                      if (skeletonOption.showContent)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: FractionallySizedBox(
                            widthFactor: skeletonOption.subtitleWidth,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: dense_ ? 12.0 : 13.0,
                              color: skeletonBaseColor_,
                            ),
                          ),
                        ),
                      // if (subtitleWidget != null) subtitleWidget,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Widget? leadingWidget;
      Widget? titleWidget;
      Widget? subtitleWidget;
      Widget? trailingWidget;
      if (leading != null || leadingIcon != null || reserveLeadingSpace) {
        IconThemeData leadingIconThemeData = IconThemeData(
          color: _leadingIconColor(theme, tileTheme),
          size: leadingIconSize ?? 24,
        );
        TextStyle leadingTextStyle = _leadingTextStyle(theme, tileTheme);

        late Widget leadingInner_;
        if (leading != null) {
          leadingInner_ = leading!;
        } else if (leadingIcon != null) {
          leadingInner_ = Icon(leadingIcon);
        } else if (reserveLeadingSpace) {
          leadingInner_ = const SizedBox(width: 24);
        }

        leadingWidget = Padding(
          padding: EdgeInsets.only(right: horizontalTitleGap_),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: minLeadingWidth ?? tileTheme.minLeadingWidth ?? 24),
            child: _gradientShader(
              child: AnimatedDefaultTextStyle(
                style: leadingTextStyle,
                duration: kThemeChangeDuration,
                child: IconTheme.merge(
                  data: leadingIconThemeData,
                  child: leadingInner_,
                ),
              ),
            ),
          ),
        );
      }

      if (title != null || titleText != null) {
        titleWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: _gradientShader(
            child: AnimatedDefaultTextStyle(
              duration: kThemeChangeDuration,
              style: _titleTextStyle(theme, tileTheme),
              child: title ?? Text(titleText ?? ''),
            ),
          ),
        );
      }

      if (subtitle != null || subtitleText != null) {
        subtitleWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: _gradientShader(
            child: AnimatedDefaultTextStyle(
              duration: kThemeChangeDuration,
              style: subtitleTextStyle ?? _subtitleTextStyle(theme, tileTheme),
              child: subtitle ?? Text(subtitleText ?? ''),
            ),
          ),
        );
      }

      if (loading || trailing != null || selected || isRadio) {
        IconThemeData trailingIconThemeData = IconThemeData(
          color: _trailingIconColor(theme, tileTheme),
          size: 22,
        );
        TextStyle trailingTextStyle = _trailingTextStyle(theme, tileTheme);
        late Widget trailingInnerWidget;
        if (loading) {
          trailingInnerWidget = SizedBox(
            width: loadingWidth ?? 20,
            height: 20,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).disabledColor),
                ),
              ),
            ),
          );
        } else if (isRadio) {
          trailingInnerWidget = CRadioIcon(
            selected: selected,
            enabled: onTap != null,
            size: radioSize,
            color: _trailingIconColor(theme, tileTheme),
          );
        } else if (trailing != null) {
          trailingInnerWidget = trailing!;
        } else if (selected) {
          trailingInnerWidget = const Icon(Icons.check);
        }
        trailingWidget = Padding(
          padding: EdgeInsets.only(left: horizontalTitleGap_),
          child: _gradientShader(
            child: AnimatedDefaultTextStyle(
              style: trailingTextStyle,
              duration: kThemeChangeDuration,
              child: IconTheme.merge(
                data: trailingIconThemeData,
                child: trailingInnerWidget,
              ),
            ),
          ),
        );
      }

      innerRow_ = Row(
        crossAxisAlignment: rowAlignment,
        children: [
          AnimatedSize(
            duration: _kAnimationSizeDuration,
            curve: Curves.ease,
            child: leadingWidget ?? const SizedBox.shrink(),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight_),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (titleWidget != null) titleWidget,
                    if (subtitleWidget != null) subtitleWidget,
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: _kAnimationSizeDuration,
            curve: Curves.ease,
            child: trailingWidget ?? const SizedBox.shrink(),
          ),
          if (arrow && !loading && !selected)
            Transform.translate(
              offset: const Offset(6.0, 0.0),
              child: Icon(
                Icons.chevron_right,
                color: theme.disabledColor,
                size: 20,
              ),
            ),
        ],
      );
    }

    final EdgeInsetsGeometry contentPadding_ = contentPadding ??
        theme.listTileTheme.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: _kDefaultPadding,
        );

    return CInk(
      // style: PlatformStyle.material,
      color: tileBackgroundColorVal_,
      onTap: _enabled && onTap != null
          ? () {
              FocusManager.instance.primaryFocus?.unfocus();
              onTap?.call();
            }
          : null,
      onLongPress: _enabled ? onLongPress : null,
      cupertinoOption:
          const CInkCupertinoOption(cupertinoInkStyle: CupertinoInkStyle.shade),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dividerTop)
            Divider(
              height: 1,
              thickness: dividerThickness,
              indent: dividerInsets ? _kDefaultPadding : 0,
              endIndent: dividerInsets ? _kDefaultPadding : 0,
            ),
          Padding(
            padding: contentPadding_,
            child: innerRow_,
          ),
          if (dividerBottom)
            Divider(
              height: 1,
              thickness: dividerThickness,
              indent: dividerInsets ? _kDefaultPadding : 0,
              endIndent: dividerInsets ? _kDefaultPadding : 0,
            ),
        ],
      ),
    );
  }
}
