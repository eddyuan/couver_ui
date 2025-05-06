// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:couver_ui/src/core/skeleton/widget.c_skeleton_text.dart';

import '../buttons/widget.c_button.dart';

class CRichTextConfig {
  final TextStyle? style;
  final VoidCallback? onTap;
  final InlineSpan Function(BuildContext context, String text)?
      widgetSpanBuilder;
  const CRichTextConfig({
    this.style,
    this.onTap,
    this.widgetSpanBuilder,
  });
}

class CRichText extends StatefulWidget {
  const CRichText(
    this.data, {
    this.tagConfig,
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.expandable = false,
    this.expandButtonBuilder,
    this.expandText = "Show more",
    this.collapseText = "Show less",
    this.expandDuration = Durations.short4,
    this.expandAlignment = Alignment.topCenter,
    this.expandBtnColor,
    this.expandBtnSize,
    this.loading = false,
    this.loadingLines = 1,
    this.loadingWidth = 0.6,
    this.loadingColor,
    this.loadingColor2,
    this.gradient,
  }) : textSpan = null;

  const CRichText.rich(
    InlineSpan this.textSpan, {
    this.tagConfig,
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.expandable = false,
    this.expandButtonBuilder,
    this.expandText = "Show more",
    this.collapseText = "Show less",
    this.expandDuration = Durations.short4,
    this.expandAlignment = Alignment.topCenter,
    this.expandBtnSize,
    this.expandBtnColor,
    this.loading = false,
    this.loadingLines = 1,
    this.loadingWidth = 0.6,
    this.loadingColor,
    this.loadingColor2,
    this.gradient,
  }) : data = null;

  final Map<String, CRichTextConfig>? tagConfig;
  final String? data;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  final double? textScaleFactor;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// const Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  ///
  /// This is ignored if [SelectionContainer.maybeOf] returns null
  /// in the [BuildContext] of the [Text] widget.
  ///
  /// If null, the ambient [DefaultSelectionStyle] is used (if any); failing
  /// that, the selection color defaults to [DefaultSelectionStyle.defaultColor]
  /// (semi-transparent grey).
  final Color? selectionColor;

  final bool expandable;

  final Widget Function(bool expanded, VoidCallback toggle)?
      expandButtonBuilder;

  final String expandText;

  final String collapseText;

  final Duration expandDuration;

  final AlignmentGeometry expandAlignment;

  final Color? expandBtnColor;

  final BtnSize? expandBtnSize;

  /// Show skeleton
  final bool loading;

  final int loadingLines;
  final Color? loadingColor;
  final Color? loadingColor2;

  /// <=1: Fraction, >1 : Size
  final double loadingWidth;

  final InlineSpan? textSpan;

  final Gradient? gradient;

  @override
  State<CRichText> createState() => _CRichTextState();
}

class _CRichTextState extends State<CRichText> {
  bool expanded = false;

  void onToggle() {
    setState(() {
      expanded = !expanded;
    });
  }

  Widget expandButtonBuilder(bool expanded, VoidCallback toggle) {
    if (widget.expandButtonBuilder != null) {
      return widget.expandButtonBuilder!(expanded, toggle);
    }
    return Align(
      alignment: Alignment.topRight,
      child: CButton(
        size: widget.expandBtnSize ?? BtnSize.df,
        color: widget.expandBtnColor,
        text: expanded ? widget.collapseText : widget.expandText,
        onPressed: toggle,
        iconRight: expanded ? Icons.arrow_upward : Icons.arrow_downward,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return CSkeletonText(
        style: widget.style,
        lines: widget.loadingLines,
        lastLineWidth: widget.loadingWidth,
        textAlign: widget.textAlign,
        color: widget.loadingColor,
        color2: widget.loadingColor2,
      );
    }

    if ((widget.data?.isEmpty ?? true) && widget.textSpan == null) {
      return const SizedBox.shrink();
    }

    final maxLines = (widget.maxLines ?? 0) > 0 ? widget.maxLines : null;

    final textSpan =
        widget.textSpan ?? _buildTextSpan(widget.data ?? "", context);
    final maxLinesCurrent = expanded ? null : maxLines;
    final finalTextWidget = _buildGradient(
        gradient: widget.gradient,
        child: Text.rich(
          textSpan,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap,
          overflow: maxLinesCurrent == null
              ? null
              : (widget.overflow ?? TextOverflow.ellipsis),
          textScaleFactor: widget.textScaleFactor,
          textScaler: widget.textScaler,
          maxLines: maxLinesCurrent,
          semanticsLabel: widget.semanticsLabel,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
          selectionColor: widget.selectionColor,
        ));

    if (!widget.expandable || maxLines == null) {
      return finalTextWidget;
    }

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textScaleFactor: widget.textScaleFactor ?? 1.0,
      textScaler: widget.textScaler ?? TextScaler.noScaling,
      maxLines: maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: widget.textHeightBehavior,
      // ellipsis: "...",
    );

    return LayoutBuilder(builder: (ctx, cst) {
      try {
        textPainter.layout(maxWidth: cst.maxWidth);
        final hasOverflow = textPainter.didExceedMaxLines;
        if (!hasOverflow) {
          return finalTextWidget;
          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     finalTextWidget,
          //     Text(maxLinesCurrent.toString()),
          //     Text(hasOverflow.toString()),
          //     CustomPaint(
          //       size: textPainter.size,
          //       painter: _TestPainter(textPainter: textPainter),
          //     ),
          //     Text.rich(
          //       TextSpan(
          //         children: [textPainter.text!],
          //       ),
          //     ),
          //   ],
          // );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: widget.expandDuration,
              alignment: widget.expandAlignment,
              child: finalTextWidget,
            ),
            expandButtonBuilder(expanded, onToggle),
            // Text(hasOverflow.toString()),
            // Text(maxLinesCurrent.toString()),
            // CustomPaint(
            //   painter: _TestPainter(textPainter: textPainter),
            // ),
          ],
        );
      } catch (e) {
        return finalTextWidget;
      }
      // final hasOverflow = textPainter.didExceedMaxLines;
      // // final int targetLines = textPainter.computeLineMetrics().length;
      // // print("targetLines $targetLines");
      // if (!hasOverflow) {
      //   return finalTextWidget;
      // }
      // if (targetLines <= maxLines) {
      //   return finalTextWidget;
      // }
    });
  }

  /// 解析带有自定义标签的文本，并根据标签应用样式和点击事件
  InlineSpan _buildTextSpan(String text, BuildContext context) {
    final TextStyle baseStyle = widget.style ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();

    if (!text.contains("<") || !text.contains(">")) {
      return TextSpan(text: text, style: baseStyle);
    }

    final double baseFontSize = baseStyle.fontSize ?? 14;
    // 定义默认标签样式
    Map<String, CRichTextConfig> styles = {
      "b": const CRichTextConfig(
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      "small": CRichTextConfig(
        style: TextStyle(fontSize: baseFontSize * 0.8),
      ),
      "u": const CRichTextConfig(
        style: TextStyle(
          decorationStyle: TextDecorationStyle.solid,
          decoration: TextDecoration.underline,
        ),
      ),
    };

    // 合并外部传入的标签样式，覆盖已有样式
    if (widget.tagConfig != null) {
      styles.addAll(widget.tagConfig!);
    }

    // 初始化 TextSpan 列表和当前索引
    List<InlineSpan> spans = [];
    int currentIndex = 0;

    // 定义用于匹配标签的正则表达式，例如 <b>标签内容</b>
    final tagRegex = RegExp(r'<(\w+)>(.*?)<\/\1>');

    // 遍历所有匹配到的标签
    for (final match in tagRegex.allMatches(text)) {
      // 处理标签前的普通文本
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
        ));
      }

      // 提取标签名称和内容
      final tag = match.group(1); // 标签名，例如 b、u
      final content = match.group(2); // 标签内的文本内容
      final config = styles[tag]; // 获取对应标签的样式配置

      // 根据标签配置应用样式和点击事件
      spans.add(
        config?.widgetSpanBuilder?.call(context, content ?? "") ??
            TextSpan(
              text: content,
              style: config?.style != null
                  ? baseStyle.merge(config!.style) // 合并全局和标签样式
                  : null,
              recognizer: config?.onTap != null
                  ? (TapGestureRecognizer()..onTap = config!.onTap) // 应用点击事件
                  : null,
            ),
      );

      // 更新当前索引到标签的结束位置
      currentIndex = match.end;
    }

    // 处理最后一个标签后的普通文本
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    // 返回包含所有文本和样式的 TextSpan
    return TextSpan(children: spans);
  }
}

Widget _buildGradient({
  Gradient? gradient,
  required Widget child,
}) {
  if (gradient == null) return child;
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => gradient.createShader(
      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    ),
    child: child,
  );
}

class _TestPainter extends CustomPainter {
  final TextPainter textPainter;
  _TestPainter({
    required this.textPainter,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
