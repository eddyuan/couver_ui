// // Copyright 2014 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import "dart:math" as math;

// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
// import "package:flutter/rendering.dart";

// import '../../enums/enum.platform_style.dart';

// const double _kMinButtonSize = kMinInteractiveDimension;

// // import "extensions.dart";

// // Minimum logical pixel size of the CIconButton.
// // See: <https://material.io/design/usability/accessibility.html#layout-typography>.
// // const double _kMinButtonSize = kMinInteractiveDimension;

// /// A material design icon button.
// ///
// /// An icon button is a picture printed on a [Material] widget that reacts to
// /// touches by filling with color (ink).
// ///
// /// Icon buttons are commonly used in the [AppBar.actions] field, but they can
// /// be used in many other places as well.
// ///
// /// If the [onPressed] callback is null, then the button will be disabled and
// /// will not react to touch.
// ///
// /// Requires one of its ancestors to be a [Material] widget.
// ///
// /// The hit region of an icon button will, if possible, be at least
// /// kMinInteractiveDimension pixels in size, regardless of the actual
// /// [iconSize], to satisfy the [touch target size](https://material.io/design/layout/spacing-methods.html#touch-targets)
// /// requirements in the Material Design specification. The [alignment] controls
// /// how the icon itself is positioned within the hit region.
// ///
// /// {@tool dartpad}
// /// This sample shows an `CIconButton` that uses the Material icon "volume_up" to
// /// increase the volume.
// ///
// /// ![](https://flutter.github.io/assets-for-api-docs/assets/material/icon_button.png)
// ///
// /// ** See code in examples/api/lib/material/icon_button/icon_button.0.dart **
// /// {@end-tool}
// ///
// /// ### Icon sizes
// ///
// /// When creating an icon button with an [Icon], do not override the
// /// icon's size with its [Icon.size] parameter, use the icon button's
// /// [iconSize] parameter instead.  For example do this:
// ///
// /// ```dart
// /// CIconButton(iconSize: 72, icon: Icon(Icons.favorite), ...)
// /// ```
// ///
// /// Avoid doing this:
// ///
// /// ```dart
// /// CIconButton(icon: Icon(Icons.favorite, size: 72), ...)
// /// ```
// ///
// /// If you do, the button's size will be based on the default icon
// /// size, not 72, which may produce unexpected layouts and clipping
// /// issues.
// ///
// /// ### Adding a filled background
// ///
// /// Icon buttons don't support specifying a background color or other
// /// background decoration because typically the icon is just displayed
// /// on top of the parent widget's background. Icon buttons that appear
// /// in [AppBar.actions] are an example of this.
// ///
// /// It's easy enough to create an icon button with a filled background
// /// using the [Ink] widget. The [Ink] widget renders a decoration on
// /// the underlying [Material] along with the splash and highlight
// /// [InkResponse] contributed by descendant widgets.
// ///
// /// {@tool dartpad}
// /// In this sample the icon button's background color is defined with an [Ink]
// /// widget whose child is an [CIconButton]. The icon button's filled background
// /// is a light shade of blue, it's a filled circle, and it's as big as the
// /// button is.
// ///
// /// ![](https://flutter.github.io/assets-for-api-docs/assets/material/icon_button_background.png)
// ///
// /// ** See code in examples/api/lib/material/icon_button/icon_button.1.dart **
// /// {@end-tool}
// ///
// /// See also:
// ///
// ///  * [Icons], a library of predefined icons.
// ///  * [BackButton], an icon button for a "back" affordance which adapts to the
// ///    current platform's conventions.
// ///  * [CloseButton], an icon button for closing pages.
// ///  * [AppBar], to show a toolbar at the top of an application.
// ///  * [TextButton], [ElevatedButton], [OutlinedButton], for buttons with text labels and an optional icon.
// ///  * [InkResponse] and [InkWell], for the ink splash effect itself.
// class CIconButton extends StatefulWidget {
//   /// Creates an icon button.
//   ///
//   /// Icon buttons are commonly used in the [AppBar.actions] field, but they can
//   /// be used in many other places as well.
//   ///
//   /// Requires one of its ancestors to be a [Material] widget.
//   ///
//   /// The [iconSize], [padding], [autofocus], and [alignment] arguments must not
//   /// be null (though they each have default values).
//   ///
//   /// The [icon] argument must be specified, and is typically either an [Icon]
//   /// or an [ImageIcon].
//   const CIconButton({
//     Key? key,
//     this.iconSize,
//     this.visualDensity,
//     this.padding = const EdgeInsets.all(8.0),
//     this.alignment = Alignment.center,
//     this.splashRadius,
//     this.color,
//     this.focusColor,
//     this.hoverColor,
//     this.highlightColor,
//     this.splashColor,
//     this.disabledColor,
//     required this.onPressed,
//     this.mouseCursor,
//     this.focusNode,
//     this.autofocus = false,
//     this.tooltip,
//     this.enableFeedback = true,
//     this.constraints,
//     required this.icon,
//     this.platformStyle = PlatformStyle.auto,
//     this.loading,
//     this.restrictWidth = true,
//   })  : assert(splashRadius == null || splashRadius > 0),
//         super(key: key);

//   final bool restrictWidth;

//   final PlatformStyle platformStyle;

//   final bool? loading;

//   bool get isLoading => loading ?? false;

//   /// The size of the icon inside the button.
//   ///
//   /// If null, uses [IconThemeData.size]. If it is also null, the default size
//   /// is 24.0.
//   ///
//   /// The size given here is passed down to the widget in the [icon] property
//   /// via an [IconTheme]. Setting the size here instead of in, for example, the
//   /// [Icon.size] property allows the [CIconButton] to size the splash area to
//   /// fit the [Icon]. If you were to set the size of the [Icon] using
//   /// [Icon.size] instead, then the [CIconButton] would default to 24.0 and then
//   /// the [Icon] itself would likely get clipped.
//   final double? iconSize;

//   /// Defines how compact the icon button's layout will be.
//   ///
//   /// {@macro flutter.material.themedata.visualDensity}
//   ///
//   /// See also:
//   ///
//   ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
//   ///    widgets within a [Theme].
//   final VisualDensity? visualDensity;

//   /// The padding around the button's icon. The entire padded icon will react
//   /// to input gestures.
//   ///
//   /// This property must not be null. It defaults to 8.0 padding on all sides.
//   final EdgeInsetsGeometry padding;

//   /// Defines how the icon is positioned within the CIconButton.
//   ///
//   /// This property must not be null. It defaults to [Alignment.center].
//   ///
//   /// See also:
//   ///
//   ///  * [Alignment], a class with convenient constants typically used to
//   ///    specify an [AlignmentGeometry].
//   ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
//   ///    relative to text direction.
//   final AlignmentGeometry alignment;

//   /// The splash radius.
//   ///
//   /// If null, default splash radius of [Material.defaultSplashRadius] is used.
//   final double? splashRadius;

//   /// The icon to display inside the button.
//   ///
//   /// The [Icon.size] and [Icon.color] of the icon is configured automatically
//   /// based on the [iconSize] and [color] properties of _this_ widget using an
//   /// [IconTheme] and therefore should not be explicitly given in the icon
//   /// widget.
//   ///
//   /// This property must not be null.
//   ///
//   /// See [Icon], [ImageIcon].
//   final Widget icon;

//   /// The color for the button's icon when it has the input focus.
//   ///
//   /// Defaults to [ThemeData.focusColor] of the ambient theme.
//   final Color? focusColor;

//   /// The color for the button's icon when a pointer is hovering over it.
//   ///
//   /// Defaults to [ThemeData.hoverColor] of the ambient theme.
//   final Color? hoverColor;

//   /// The color to use for the icon inside the button, if the icon is enabled.
//   /// Defaults to leaving this up to the [icon] widget.
//   ///
//   /// The icon is enabled if [onPressed] is not null.
//   ///
//   /// ```dart
//   /// CIconButton(
//   ///   color: Colors.blue,
//   ///   onPressed: _handleTap,
//   ///   icon: Icons.widgets,
//   /// )
//   /// ```
//   final Color? color;

//   /// The primary color of the button when the button is in the down (pressed) state.
//   /// The splash is represented as a circular overlay that appears above the
//   /// [highlightColor] overlay. The splash overlay has a center point that matches
//   /// the hit point of the user touch event. The splash overlay will expand to
//   /// fill the button area if the touch is held for long enough time. If the splash
//   /// color has transparency then the highlight and button color will show through.
//   ///
//   /// Defaults to the Theme's splash color, [ThemeData.splashColor].
//   final Color? splashColor;

//   /// The secondary color of the button when the button is in the down (pressed)
//   /// state. The highlight color is represented as a solid color that is overlaid over the
//   /// button color (if any). If the highlight color has transparency, the button color
//   /// will show through. The highlight fades in quickly as the button is held down.
//   ///
//   /// Defaults to the Theme's highlight color, [ThemeData.highlightColor].
//   final Color? highlightColor;

//   /// The color to use for the icon inside the button, if the icon is disabled.
//   /// Defaults to the [ThemeData.disabledColor] of the current [Theme].
//   ///
//   /// The icon is disabled if [onPressed] is null.
//   final Color? disabledColor;

//   /// The callback that is called when the button is tapped or otherwise activated.
//   ///
//   /// If this is set to null, the button will be disabled.
//   final VoidCallback? onPressed;

//   /// {@macro flutter.material.RawMaterialButton.mouseCursor}
//   ///
//   /// If set to null, will default to
//   /// - [SystemMouseCursors.forbidden], if [onPressed] is null
//   /// - [SystemMouseCursors.click], otherwise
//   final MouseCursor? mouseCursor;

//   /// {@macro flutter.widgets.Focus.focusNode}
//   final FocusNode? focusNode;

//   /// {@macro flutter.widgets.Focus.autofocus}
//   final bool autofocus;

//   /// Text that describes the action that will occur when the button is pressed.
//   ///
//   /// This text is displayed when the user long-presses on the button and is
//   /// used for accessibility.
//   final String? tooltip;

//   /// Whether detected gestures should provide acoustic and/or haptic feedback.
//   ///
//   /// For example, on Android a tap will produce a clicking sound and a
//   /// long-press will produce a short vibration, when feedback is enabled.
//   ///
//   /// See also:
//   ///
//   ///  * [Feedback] for providing platform-specific feedback to certain actions.
//   final bool enableFeedback;

//   /// Optional size constraints for the button.
//   ///
//   /// When unspecified, defaults to:
//   /// ```dart
//   /// const BoxConstraints(
//   ///   minWidth: kMinInteractiveDimension,
//   ///   minHeight: kMinInteractiveDimension,
//   /// )
//   /// ```
//   /// where [kMinInteractiveDimension] is 48.0, and then with visual density
//   /// applied.
//   ///
//   /// The default constraints ensure that the button is accessible.
//   /// Specifying this parameter enables creation of buttons smaller than
//   /// the minimum size, but it is not recommended.
//   ///
//   /// The visual density uses the [visualDensity] parameter if specified,
//   /// and `Theme.of(context).visualDensity` otherwise.
//   final BoxConstraints? constraints;

//   bool get enabled => onPressed != null && !isLoading;

//   @override
//   State<CIconButton> createState() => _CIconButtonState();
// }

// class _CIconButtonState extends State<CIconButton>
//     with TickerProviderStateMixin {
//   // Cupertino animation =======================================================

//   // static const Duration kFadeOutDuration = Duration(milliseconds: 40);
//   static const Duration kFadeInDuration = Duration(milliseconds: 600);
//   final Tween<double> _cupertinoOpacityTween = Tween<double>(begin: 1.0);

//   AnimationController? _cupertinoAnimationController;
//   Animation<double>? _cupertinoOpacityAnimation;

//   void _setTween() {
//     _cupertinoOpacityTween.end = 0.4;
//   }

//   bool _cupertinoButtonHeldDown = false;

//   void _doCupertinoAnimate(bool val) {
//     _cupertinoButtonHeldDown = val;
//     _cupertinoAnimate();
//   }

//   void _cupertinoAnimate() {
//     if (_cupertinoAnimationController != null) {
//       if (_cupertinoButtonHeldDown) {
//         _cupertinoAnimationController!.value = 1.0;
//       } else {
//         _cupertinoAnimationController!.animateTo(0.0,
//             duration: kFadeInDuration, curve: Curves.decelerate);
//       }
//       // final bool wasHeldDown = _cupertinoButtonHeldDown;
//       // final TickerFuture ticker = _cupertinoButtonHeldDown
//       //     ? _cupertinoAnimationController!
//       //         .animateTo(1.0, duration: kFadeOutDuration, curve: Curves.ease)
//       //     : _cupertinoAnimationController!
//       //         .animateTo(0.0, duration: kFadeInDuration, curve: Curves.ease);
//       // ticker.then<void>((void value) {
//       //   if (mounted && wasHeldDown != _cupertinoButtonHeldDown) {
//       //     _cupertinoAnimate();
//       //   }
//       // });
//     }
//   }

//   void _initCupertinoAnimation() {
//     _cupertinoAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       value: 0.0,
//       vsync: this,
//     );
//     _cupertinoOpacityAnimation = _cupertinoAnimationController!
//         .drive(CurveTween(curve: Curves.decelerate))
//         .drive(_cupertinoOpacityTween);
//     _setTween();
//   }

//   //=======================================================
//   @override
//   void initState() {
//     super.initState();
//     if (widget.platformStyle.isIos) {
//       _initCupertinoAnimation();
//     }
//   }

//   @override
//   void dispose() {
//     _cupertinoAnimationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // assert(debugCheckHasMaterial(context));
//     final ThemeData theme = Theme.of(context);
//     Color? currentColor;
//     if (widget.enabled) {
//       currentColor = widget.color;
//     } else {
//       currentColor = widget.disabledColor ?? theme.disabledColor;
//     }

//     final VisualDensity effectiveVisualDensity =
//         widget.visualDensity ?? theme.visualDensity;

//     final BoxConstraints unadjustedConstraints = widget.constraints ??
//         const BoxConstraints(
//           minWidth: _kMinButtonSize,
//           minHeight: _kMinButtonSize,
//         );
//     final BoxConstraints adjustedConstraints =
//         effectiveVisualDensity.effectiveConstraints(unadjustedConstraints);
//     final double effectiveIconSize =
//         widget.iconSize ?? IconTheme.of(context).size ?? 24.0;

//     Widget result = FadeTransition(
//       opacity:
//           _cupertinoOpacityAnimation ?? const AlwaysStoppedAnimation<double>(1),
//       child: ConstrainedBox(
//         constraints: adjustedConstraints,
//         child: Padding(
//           padding: widget.padding,
//           child: SizedBox(
//             height: effectiveIconSize,
//             width: widget.restrictWidth ? effectiveIconSize : null,
//             child: Align(
//               alignment: widget.alignment,
//               child: DefaultTextStyle.merge(
//                 style: TextStyle(
//                   color: currentColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 child: IconTheme.merge(
//                   data: IconThemeData(
//                     size: effectiveIconSize,
//                     color: currentColor,
//                   ),
//                   child: widget.isLoading
//                       ? SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator.adaptive(
//                             strokeWidth: 3,
//                             valueColor: AlwaysStoppedAnimation(currentColor),
//                             backgroundColor: currentColor?.withOpacity(0.1),
//                           ),
//                         )
//                       : widget.icon,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     if (widget.tooltip != null) {
//       result = Tooltip(
//         message: widget.tooltip,
//         child: result,
//       );
//     }

//     return Semantics(
//       button: true,
//       enabled: widget.enabled,
//       child: InkResponse(
//         // onTapDown: (v) =>
//         //     widget.platformStyle.isIos ? _doCupertinoAnimate(true) : null,
//         // onTapUp: (v) =>
//         //     widget.platformStyle.isIos ? _doCupertinoAnimate(false) : null,
//         onHighlightChanged:
//             widget.platformStyle.isIos ? _doCupertinoAnimate : null,
//         focusNode: widget.focusNode,
//         autofocus: widget.autofocus,
//         canRequestFocus: false, // widget.enabled,
//         onTap: widget.enabled ? widget.onPressed : null,
//         mouseCursor: widget.mouseCursor ??
//             (widget.enabled
//                 ? SystemMouseCursors.forbidden
//                 : SystemMouseCursors.click),
//         enableFeedback: widget.enableFeedback,
//         splashFactory:
//             widget.platformStyle.isIos ? NoSplash.splashFactory : null,
//         focusColor: widget.focusColor ?? theme.focusColor,
//         hoverColor: widget.hoverColor ?? theme.hoverColor,
//         highlightColor: widget.platformStyle.isIos
//             ? Colors.transparent
//             : (widget.highlightColor ?? theme.highlightColor),
//         splashColor: widget.platformStyle.isIos
//             ? Colors.transparent
//             : (widget.splashColor ?? theme.splashColor),
//         radius: widget.platformStyle.isIos
//             ? null
//             : (widget.splashRadius ??
//                 math.max(
//                   Material.defaultSplashRadius,
//                   (effectiveIconSize +
//                           math.min(widget.padding.horizontal,
//                               widget.padding.vertical)) *
//                       0.7,
//                   // x 0.5 for diameter -> radius and + 40% overflow derived from other Material apps.
//                 )),
//         child: result,
//       ),
//     );
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//         .add(DiagnosticsProperty<Widget>("icon", widget.icon, showName: false));
//     properties.add(StringProperty("tooltip", widget.tooltip,
//         defaultValue: null, quoted: false));
//     properties.add(ObjectFlagProperty<VoidCallback>(
//         "onPressed", widget.onPressed,
//         ifNull: "disabled"));
//     properties.add(ColorProperty("color", widget.color, defaultValue: null));
//     properties.add(ColorProperty("disabledColor", widget.disabledColor,
//         defaultValue: null));
//     properties.add(
//         ColorProperty("focusColor", widget.focusColor, defaultValue: null));
//     properties.add(
//         ColorProperty("hoverColor", widget.hoverColor, defaultValue: null));
//     properties.add(ColorProperty("highlightColor", widget.highlightColor,
//         defaultValue: null));
//     properties.add(
//         ColorProperty("splashColor", widget.splashColor, defaultValue: null));
//     properties.add(DiagnosticsProperty<EdgeInsetsGeometry>(
//         "padding", widget.padding,
//         defaultValue: null));
//     properties.add(DiagnosticsProperty<FocusNode>("focusNode", widget.focusNode,
//         defaultValue: null));
//   }
// }
