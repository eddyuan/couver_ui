// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';

// import 'utils.dart';
import 'widget.c_icon_button.dart';

// /// A "back" icon that's appropriate for the current [TargetPlatform].
// ///
// /// The current platform is determined by querying for the ambient [Theme].
// ///
// /// See also:
// ///
// ///  * [CBackButton], an [IconButton] with a [CBackButtonIcon] that calls
// ///    [Navigator.maybePop] to return to the previous route.
// ///  * [IconButton], which is a more general widget for creating buttons
// ///    with icons.
// ///  * [Icon], a material design icon.
// ///  * [ThemeData.platform], which specifies the current platform.
// class CBackButtonIcon extends StatelessWidget {
//   /// Creates an icon that shows the appropriate "back" image for
//   /// the current platform (as obtained from the [Theme]).
//   const CBackButtonIcon({Key? key}) : super(key: key);

//   /// Returns the appropriate "back" icon for the given `platform`.
//   static IconData _getIconData(TargetPlatform platform) {
//     switch (platform) {
//       case TargetPlatform.android:
//       case TargetPlatform.fuchsia:
//       case TargetPlatform.linux:
//       case TargetPlatform.windows:
//         return Icons.arrow_back;
//       case TargetPlatform.iOS:
//       case TargetPlatform.macOS:
//         return Icons.arrow_back_ios;
//     }
//   }

//   @override
//   Widget build(BuildContext context) =>
//       Icon(_getIconData(Theme.of(context).platform));
// }

/// A material design back button.
///
/// A [CBackButton] is an [IconButton] with a "back" icon appropriate for the
/// current [TargetPlatform]. When pressed, the back button calls
/// [Navigator.maybePop] to return to the previous route unless a custom
/// [onPressed] callback is provided.
///
/// When deciding to display a [CBackButton], consider using
/// `ModalRoute.of(context)?.canPop` to check whether the current route can be
/// popped. If that value is false (e.g., because the current route is the
/// initial route), the [CBackButton] will not have any effect when pressed,
/// which could frustrate the user.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [AppBar], which automatically uses a [CBackButton] in its
///    [AppBar.leading] slot when the [Scaffold] has no [Drawer] and the
///    current [Route] is not the [Navigator]'s first route.
///  * [CBackButtonIcon], which is useful if you need to create a back button
///    that responds differently to being pressed.
///  * [IconButton], which is a more general widget for creating buttons with
///    icons.
///  * [CCloseButton], an alternative which may be more appropriate for leaf
///    node pages in the navigation tree.
class CBackButton extends StatelessWidget {
  /// Creates an [IconButton] with the appropriate "back" icon for the current
  /// target platform.
  const CBackButton({
    Key? key,
    this.color,
    this.onPressed,
    this.heroTag = '',
  }) : super(key: key);

  final String? heroTag;

  /// The color to use for the icon.
  ///
  /// Defaults to the [IconThemeData.color] specified in the ambient [IconTheme],
  /// which usually matches the ambient [Theme]'s [ThemeData.iconTheme].
  final Color? color;

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack
  /// via [SystemNavigator] instead of Flutter's [Navigator] in add-to-app
  /// situations.
  ///
  /// Defaults to null.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String? heroTag_ = heroTag;
    if (Platform.isIOS && heroTag != null && heroTag!.isEmpty) {
      heroTag_ = 'BackButtonHeroTag';
    }
    Widget result = CIconButton(
      // platformStyle: PlatformStyle.material,
      icon: (heroTag_ is String && heroTag_.isNotEmpty)
          ? const Hero(
              tag: 'BackButtonHeroTag',
              transitionOnUserGestures: true,
              child: Icon(Icons.arrow_back),
            )
          : const Icon(Icons.arrow_back),
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed?.call();
        } else {
          Navigator.maybePop(context);
        }
      },
    );

    return result;
  }
}

/// A material design close button.
///
/// A [CCloseButton] is an [IconButton] with a "close" icon. When pressed, the
/// close button calls [Navigator.maybePop] to return to the previous route.
///
/// Use a [CCloseButton] instead of a [CBackButton] on fullscreen dialogs or
/// pages that may solicit additional actions to close.
///
/// See also:
///
///  * [AppBar], which automatically uses a [CCloseButton] in its
///    [AppBar.leading] slot when appropriate.
///  * [CBackButton], which is more appropriate for middle nodes in the
///    navigation tree or where pages can be popped instantaneously with
///    no user data consequence.
///  * [IconButton], to create other material design icon buttons.
class CCloseButton extends StatelessWidget {
  /// Creates a Material Design close button.
  const CCloseButton({
    Key? key,
    this.color,
    this.onPressed,
    // this.heroTag,
  }) : super(key: key);

  /// Add a hero
  // final String? heroTag;

  /// The color to use for the icon.
  ///
  /// Defaults to the [IconThemeData.color] specified in the ambient [IconTheme],
  /// which usually matches the ambient [Theme]'s [ThemeData.iconTheme].
  final Color? color;

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack
  /// via [SystemNavigator] instead of Flutter's [Navigator] in add-to-app
  /// situations.
  ///
  /// Defaults to null.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    Widget result = CIconButton(
      icon: const Icon(Icons.close),
      color: color,
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed?.call();
        } else {
          Navigator.maybePop(context);
        }
      },
    );

    // if (heroTag is String && heroTag!.isNotEmpty) {
    //   return Hero(tag: heroTag!, child: result);
    // }
    return result;
  }
}
