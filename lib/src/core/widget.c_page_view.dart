import "dart:math" as math;
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart'
    show precisionErrorTolerance, clampDouble;
import 'package:flutter/rendering.dart';

// import 'physics.c_snap_scroll.dart';

class CPageScrollPhysics extends ScrollPhysics {
  const CPageScrollPhysics({
    super.parent,
    // required this.itemWidth,
  });
  // final double itemWidth;
  @override
  CPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CPageScrollPhysics(
      parent: buildParent(ancestor),
      // itemWidth: itemWidth,
    );
  }

  double _getPage(ScrollMetrics position) {
    if (position is _CPagePosition) {
      return position.page!;
    }
    return position.pixels / position.viewportDimension;
    // print("_getPage");
    // print(position);
    // return position.pixels / itemWidth;
  }

  double _getPixels(ScrollMetrics position, double page) {
    // print("CPageScrollPhysics._getPixels");
    // print(" position.viewportDimension");
    // print(position.viewportDimension);
    if (position is _CPagePosition) {
      // print(position.getPixelsFromPage(page));
      return position.getPixelsFromPage(page);
    }
    return page * position.viewportDimension;
    // return math.min(page * itemWidth, position.maxScrollExtent);
    // return page * position.viewportDimension;
  }

  double _getTargetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

class CPageMetrics extends FixedScrollMetrics {
  /// Creates an immutable snapshot of values associated with a [PageView].
  CPageMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    required this.itemWidth,
    required super.devicePixelRatio,
  });

  @override
  CPageMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemWidth,
    double? devicePixelRatio,
  }) {
    return CPageMetrics(
      minScrollExtent: minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemWidth: itemWidth ?? this.itemWidth,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }

  /// The current page displayed in the [PageView].
  double? get page {
    return math.max(
            0.0, pixels.clamp(minScrollExtent, maxScrollExtent + itemWidth)) /
        (itemWidth);
    // return math.max(
    //         0.0, clampDouble(pixels, minScrollExtent, maxScrollExtent)) /
    //     math.max(1.0, viewportDimension * itemWidth);
  }

  /// The fraction of the viewport that each page occupies.
  ///
  /// Used to compute [page] from the current [pixels].
  final double itemWidth;
}

class _CPagePosition extends ScrollPositionWithSingleContext
    implements CPageMetrics {
  _CPagePosition({
    required super.physics,
    required super.context,
    this.initialPage = 0,
    bool keepPage = true,
    double itemWidth = 1.0,
    super.oldPosition,
  })  : assert(itemWidth > 0.0),
        _itemWidth = itemWidth,
        _pageToUseOnStartup = initialPage.toDouble(),
        super(
          initialPixels: null,
          keepScrollOffset: keepPage,
        );

  final int initialPage;
  double _pageToUseOnStartup;
  // When the viewport has a zero-size, the `page` can not
  // be retrieved by `getPageFromPixels`, so we need to cache the page
  // for use when resizing the viewport to non-zero next time.
  double? _cachedPage;

  @override
  Future<void> ensureVisible(
    RenderObject object, {
    double alignment = 0.0,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
    RenderObject? targetRenderObject,
  }) {
    // Since the _PagePosition is intended to cover the available space within
    // its viewport, stop trying to move the target render object to the center
    // - otherwise, could end up changing which page is visible and moving the
    // targetRenderObject out of the viewport.
    return super.ensureVisible(
      object,
      alignment: alignment,
      duration: duration,
      curve: curve,
      alignmentPolicy: alignmentPolicy,
    );
  }

  @override
  double get itemWidth => _itemWidth;
  double _itemWidth;
  set itemWidth(double value) {
    // print("setItemWidth");
    // print(value);
    if (_itemWidth == value) {
      return;
    }
    final double? oldPage = page;
    _itemWidth = value;
    if (oldPage != null) {
      // print("oldPage");
      // print(oldPage);
      // print(itemWidth);
      // print(getPixelsFromPage(oldPage));
      // jumpTo(getPixelsFromPage(oldPage));
      // forcePixels(0);
      // print('minScrollExtent');
      // print(minScrollExtent);
      // print('maxScrollExtent');
      // print(maxScrollExtent);
      forcePixels(getPixelsFromPage(oldPage));
      // forcePixels(maxScrollExtent / oldPage);
      // Future.delayed(Duration.zero, () {
      //   jumpTo(getPixelsFromPage(oldPage));
      //   // forcePixels(getPixelsFromPage(oldPage));
      // });
    }
  }

  // The amount of offset that will be added to [minScrollExtent] and subtracted
  // from [maxScrollExtent], such that every page will properly snap to the center
  // of the viewport when viewportFraction is greater than 1.
  //
  // The value is 0 if viewportFraction is less than or equal to 1, larger than 0
  // otherwise.
  // double get _initialPageOffset =>
  //     math.max(0, viewportDimension * (itemWidth - 1) / 2);

  double get _initialPageOffset => 0;

  double getPageFromPixels(double pixels, double viewportDimension) {
    assert(viewportDimension > 0.0);

    final double actual = math.max(
            0.0, pixels.clamp(minScrollExtent, maxScrollExtent + itemWidth)) /
        (itemWidth);
    // final double actual = math.max(0.0, pixels - _initialPageOffset) /
    //     (viewportDimension * itemWidth);
    final double round = actual.roundToDouble();

    // print("itemWidth");
    // print(itemWidth);
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  double getPixelsFromPage(double page) {
    return page * itemWidth + _initialPageOffset;
    // return page * viewportDimension * itemWidth + _initialPageOffset;
  }

  @override
  double? get page {
    assert(
      !hasPixels || hasContentDimensions,
      'Page value is only available after content dimensions are established.',
    );
    return !hasPixels || !hasContentDimensions
        ? null
        : _cachedPage ??
            getPageFromPixels(
                clampDouble(pixels, minScrollExtent, maxScrollExtent),
                viewportDimension);
  }

  @override
  void saveScrollOffset() {
    PageStorage.of(context.storageContext).writeState(context.storageContext,
        _cachedPage ?? getPageFromPixels(pixels, viewportDimension));
  }

  @override
  void restoreScrollOffset() {
    if (!hasPixels) {
      final double? value = PageStorage.of(context.storageContext)
          .readState(context.storageContext) as double?;
      if (value != null) {
        _pageToUseOnStartup = value;
      }
    }
  }

  @override
  void saveOffset() {
    context.saveOffset(
        _cachedPage ?? getPageFromPixels(pixels, viewportDimension));
  }

  @override
  void restoreOffset(double offset, {bool initialRestore = false}) {
    if (initialRestore) {
      _pageToUseOnStartup = offset;
    } else {
      jumpTo(getPixelsFromPage(offset));
    }
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final double? oldViewportDimensions =
        hasViewportDimension ? this.viewportDimension : null;
    if (viewportDimension == oldViewportDimensions) {
      return true;
    }
    final bool result = super.applyViewportDimension(viewportDimension);
    final double? oldPixels = hasPixels ? pixels : null;
    double page;
    if (oldPixels == null) {
      page = _pageToUseOnStartup;
    } else if (oldViewportDimensions == 0.0) {
      // If resize from zero, we should use the _cachedPage to recover the state.
      page = _cachedPage!;
    } else {
      page = getPageFromPixels(oldPixels, oldViewportDimensions!);
    }
    final double newPixels = getPixelsFromPage(page);

    // If the viewportDimension is zero, cache the page
    // in case the viewport is resized to be non-zero.
    _cachedPage = (viewportDimension == 0.0) ? page : null;

    if (newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }
    return result;
  }

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    assert(_cachedPage == null);

    if (other is! _CPagePosition) {
      return;
    }

    if (other._cachedPage != null) {
      _cachedPage = other._cachedPage;
    }
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final double newMinScrollExtent = minScrollExtent + _initialPageOffset;
    return super.applyContentDimensions(
      newMinScrollExtent,
      math.max(newMinScrollExtent, maxScrollExtent - _initialPageOffset),
    );
  }

  @override
  CPageMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemWidth,
    double? devicePixelRatio,
  }) {
    return CPageMetrics(
        minScrollExtent: minScrollExtent ??
            (hasContentDimensions ? this.minScrollExtent : null),
        maxScrollExtent: maxScrollExtent ??
            (hasContentDimensions ? this.maxScrollExtent : null),
        pixels: pixels ?? (hasPixels ? this.pixels : null),
        viewportDimension: viewportDimension ??
            (hasViewportDimension ? this.viewportDimension : null),
        axisDirection: axisDirection ?? this.axisDirection,
        itemWidth: itemWidth ?? this.itemWidth,
        devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio);
  }
}

class CPageController extends ScrollController {
  CPageController({
    this.initialPage = 0,
    this.keepPage = true,
    double itemWidth = 1.0,
  })  : _itemWidth = itemWidth,
        assert(itemWidth > 0.0);

  /// The page to show when first creating the [PageView].
  final int initialPage;

  final bool keepPage;

  double _itemWidth;

  double get itemWidth => _itemWidth;

  set itemWidth(double val) {
    _itemWidth = val;
    try {
      if (position is _CPagePosition) {
        final _CPagePosition pagePosition = position as _CPagePosition;
        pagePosition.itemWidth = itemWidth;
      }
    } catch (e) {}
  }

  double? get page {
    assert(
      positions.isNotEmpty,
      'PageController.page cannot be accessed before a PageView is built with it.',
    );
    assert(
      positions.length == 1,
      'The page property cannot be read when multiple PageViews are attached to '
      'the same PageController.',
    );
    final _CPagePosition position = this.position as _CPagePosition;
    return position.page;
  }

  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    final _CPagePosition position = this.position as _CPagePosition;
    if (position._cachedPage != null) {
      position._cachedPage = page.toDouble();
      return Future<void>.value();
    }

    return position.animateTo(
      position.getPixelsFromPage(page.toDouble()),
      duration: duration,
      curve: curve,
    );
  }

  void jumpToPage(int page) {
    final _CPagePosition position = this.position as _CPagePosition;
    if (position._cachedPage != null) {
      position._cachedPage = page.toDouble();
      return;
    }

    position.jumpTo(position.getPixelsFromPage(page.toDouble()));
  }

  Future<void> nextPage({required Duration duration, required Curve curve}) {
    return animateToPage(page!.round() + 1, duration: duration, curve: curve);
  }

  Future<void> previousPage(
      {required Duration duration, required Curve curve}) {
    return animateToPage(page!.round() - 1, duration: duration, curve: curve);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _CPagePosition(
      physics: physics,
      context: context,
      initialPage: initialPage,
      keepPage: keepPage,
      itemWidth: itemWidth,
      oldPosition: oldPosition,
    );
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    final _CPagePosition pagePosition = position as _CPagePosition;
    // print("attach");
    // print("itemWidth");
    // print(itemWidth);
    // print(position);
    pagePosition.itemWidth = itemWidth;
  }

  CPageController copyWith({
    int? initialPage,
    bool? keepPage,
    double? itemWidth,
  }) {
    return CPageController(
      initialPage: initialPage ?? this.initialPage,
      keepPage: keepPage ?? this.keepPage,
      itemWidth: itemWidth ?? this.itemWidth,
    );
  }
}

class CPageView extends StatefulWidget {
  const CPageView({
    super.key,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.gap = 6,
    this.itemWidth = 327,
    this.itemHeight = 178,
    this.onPageChanged,
    this.adaptMaxWidthToScreen = true,
    this.growThreshold = 0,
    this.growChildrenCount = -1,
    this.children = const <Widget>[],
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.inactiveScale,
  })  : itemBuilder = null,
        itemCount = children.length;

  const CPageView.builder({
    super.key,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.gap = 6,
    this.itemWidth = 327,
    this.itemHeight = 178,
    required this.itemBuilder,
    required this.itemCount,
    this.onPageChanged,
    this.adaptMaxWidthToScreen = true,
    this.growThreshold = 0,
    this.growChildrenCount = -1,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.inactiveScale,
  })  : children = const [];

  final CPageController? controller;

  /// Padding for the scrollView
  final EdgeInsets padding;

  final Clip clipBehavior;

  /// The space between each card
  final double gap;

  /// The width of a single item
  final double itemWidth;

  /// The height of a single item
  final double itemHeight;

  /// When page change, callback the index
  final ValueChanged<int>? onPageChanged;

  /// If true, the item can not go beyond screen maxWidth
  final bool adaptMaxWidthToScreen;

  /// Grow the item to the max width
  /// if target item width is only [growThreshold] less than the width of available space.
  final double growThreshold;

  /// Grow the item to the max width
  /// if children's length is <= than this amount
  final int growChildrenCount;

  // For BulderList
  // final List<Widget Function(BuildContext context, bool active)>?
  //     childrenBuilder;
  // For listView
  final List<Widget> children;
  // For Builder
  final int itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  // all other listView params
  final ChildIndexGetter? findChildIndexCallback;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  // final SliverChildDelegate childrenDelegate;

  /// Shrink the inactive cards?
  final double? inactiveScale;

  @override
  State<CPageView> createState() => _CPageViewState();
}

class _CPageViewState extends State<CPageView> {
  int _lastReportedPage = 0;

  late double currentPage = widget.controller?.initialPage.toDouble() ?? 0;

  Widget _buildContainerWrapper({
    required Widget child,
    required double containerWidth,
    required double currentPage,
    required int index,
  }) {
    /// curpage = 1.9
    /// index = 2
    final indexDouble = index.toDouble();
    // print("currentPage");
    // print(currentPage);
    double scale;
    if (widget.inactiveScale == null || currentPage == indexDouble) {
      scale = 1;
    } else if (currentPage - 1 >= indexDouble ||
        currentPage + 1 <= indexDouble) {
      scale = widget.inactiveScale!;
    } else if (currentPage > indexDouble) {
      // print((currentPage % 1));
      scale = 1 - ((1 - widget.inactiveScale!) * (currentPage % 1));
    } else {
      scale = 1 - ((1 - widget.inactiveScale!) * (1 - (currentPage % 1)));
    }
    return SizedBox(
      width: containerWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.gap),
        child: Transform.scale(
          scale: scale,
          child: child,
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, int index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, index);
    }
    return widget.children[index];
  }

  SliverChildDelegate _buildChildrenDelegate({
    required double containerWidth,
    required double currentPage,
  }) {
    return SliverChildBuilderDelegate(
      (_, index) => _buildContainerWrapper(
        containerWidth: containerWidth,
        currentPage: currentPage,
        index: index,
        child: _buildChild(_, index),
      ),
      childCount: widget.itemCount,
      findChildIndexCallback: widget.findChildIndexCallback,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double realPaddingLeft =
        math.max(0, widget.padding.left - widget.gap);
    final double realPaddingRight =
        math.max(0, widget.padding.right - widget.gap);
    final EdgeInsets scrollViewPadding = EdgeInsets.fromLTRB(
      realPaddingLeft,
      widget.padding.top,
      realPaddingRight,
      widget.padding.bottom,
    );

    final double intendedItemContainerWidth =
        widget.itemWidth + (widget.gap * 2);

    return LayoutBuilder(builder: (ctx, constraints) {
      final double maxContainerWidth =
          constraints.maxWidth - realPaddingRight - realPaddingLeft;

      double realItemContainerWidth;

      if (widget.itemCount <= widget.growChildrenCount ||
          intendedItemContainerWidth + widget.growThreshold >=
              maxContainerWidth ||
          (widget.adaptMaxWidthToScreen &&
              intendedItemContainerWidth > maxContainerWidth)) {
        realItemContainerWidth = maxContainerWidth;
      } else {
        realItemContainerWidth = widget.itemWidth + (widget.gap * 2);
      }

      // _controller.itemWidth = realItemContainerWidth;

      // final CPageController _controller = (widget.controller ??
      //     CPageController())
      //   ..itemWidth = realItemContainerWidth;

      return SizedBox(
        width: double.infinity,
        height: widget.itemHeight + widget.padding.vertical,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollUpdateNotification) {
              final CPageMetrics metrics = notification.metrics as CPageMetrics;
              // final double pageDouble = math.max(
              //         0.0,
              //         metrics.pixels.clamp(metrics.minScrollExtent,
              //             metrics.maxScrollExtent + realItemContainerWidth)) /
              //     (realItemContainerWidth);
              final double pageDouble = metrics.page ?? 0;
              final int pageInt = pageDouble.round();
              if ((pageDouble - 0.1).round() != _lastReportedPage &&
                  pageInt != _lastReportedPage) {
                widget.onPageChanged?.call(pageInt);

                _lastReportedPage = pageInt;
              }
              // print("metrics.page");
              // print(metrics.page);
              if (widget.inactiveScale != null) {
                setState(() {
                  currentPage = pageDouble;
                });
              }
            }
            return false;
          },
          child: Scrollable(
            // dragStartBehavior: widget.dragStartBehavior,
            axisDirection: AxisDirection.right,
            controller: (widget.controller ?? CPageController())
              ..itemWidth = realItemContainerWidth,
            physics: const CPageScrollPhysics(),
            clipBehavior: widget.clipBehavior,
            // restorationId: widget.restorationId,
            // scrollBehavior: widget.scrollBehavior ??
            //     ScrollConfiguration.of(context).copyWith(scrollbars: false),
            viewportBuilder: (
              BuildContext context,
              ViewportOffset position,
            ) {
              return Viewport(
                // anchor: scrollViewPadding.left / constraints.maxWidth,
                cacheExtent: 1,
                cacheExtentStyle: CacheExtentStyle.viewport,
                axisDirection: AxisDirection.right,
                offset: position,
                clipBehavior: widget.clipBehavior,
                slivers: <Widget>[
                  SliverPadding(
                    padding: scrollViewPadding,
                    // padding: EdgeInsets.only(right: scrollViewPadding.right),
                    sliver: SliverFillViewport(
                      viewportFraction:
                          realItemContainerWidth / constraints.maxWidth,
                      delegate: _buildChildrenDelegate(
                        containerWidth: realItemContainerWidth,
                        currentPage: currentPage,
                      ),
                      padEnds: false,
                    ),
                  ),
                ],
              );
            },
          ),
          // child: ListView.custom(
          //   controller: (widget.controller ?? CPageController())
          //     ..itemWidth = realItemContainerWidth,
          //   primary: false,
          //   clipBehavior: widget.clipBehavior,
          //   padding: scrollViewPadding,
          //   scrollDirection: Axis.horizontal,
          //   physics: const CPageScrollPhysics(),
          //   childrenDelegate: _buildChildrenDelegate(
          //     containerWidth: realItemContainerWidth,
          //     currentPage: currentPage,
          //   ),
          // ),
        ),
      );
    });
  }
}
