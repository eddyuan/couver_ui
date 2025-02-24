import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CTextSpanConfig {
  final TextStyle? style;
  final VoidCallback? onTap;
  const CTextSpanConfig({
    this.style,
    this.onTap,
  });
}

class CRichText extends Text {
  const CRichText(
    super.data, {
    this.tagConfig,
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  final Map<String, CTextSpanConfig>? tagConfig;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      _parseText(data ?? "", context),
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  /// 解析带有自定义标签的文本，并根据标签应用样式和点击事件
  TextSpan _parseText(String text, BuildContext context) {
    final TextStyle baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    final double baseFontSize = style?.fontSize ??
        Theme.of(context).textTheme.bodyMedium?.fontSize ??
        14;
    // 定义默认标签样式
    Map<String, CTextSpanConfig> styles = {
      "b": const CTextSpanConfig(
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      "small": CTextSpanConfig(
        style: TextStyle(fontSize: baseFontSize * 0.8),
      ),
      "u": const CTextSpanConfig(
        style: TextStyle(
          decorationStyle: TextDecorationStyle.solid,
          decoration: TextDecoration.underline,
        ),
      ),
    };

    // 合并外部传入的标签样式，覆盖已有样式
    if (tagConfig != null) {
      styles.addAll(tagConfig!);
    }

    // 初始化 TextSpan 列表和当前索引
    List<TextSpan> spans = [];
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
      spans.add(TextSpan(
        text: content,
        style: config?.style != null
            ? baseStyle.merge(config!.style) // 合并全局和标签样式
            : null,
        recognizer: config?.onTap != null
            ? (TapGestureRecognizer()..onTap = config!.onTap) // 应用点击事件
            : null,
      ));

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
