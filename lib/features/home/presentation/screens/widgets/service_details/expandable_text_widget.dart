import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final int trimLines;
  final Color color;
  final bool navigateToDetails;
  final int contractorId;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.color = ColorsManager.primaryColor,
    this.navigateToDetails = false,
    this.contractorId = 0,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = theme.textTheme.bodySmall!.copyWith(
          color: widget.color,
          height: 1.5,
        );

        final trimmedText = _getTrimmedText(
          widget.text,
          textStyle,
          constraints.maxWidth,
        );

        final shouldTrim = trimmedText != widget.text;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isExpanded ? widget.text : trimmedText, style: textStyle),
            if (shouldTrim) const SizedBox(height: 4),
            if (shouldTrim)
              GestureDetector(
                onTap: () {
                  if (widget.navigateToDetails) {
                    context.pushRoute(
                      ContractorDetailsRoute(contractorId: widget.contractorId),
                    );
                  } else {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  }
                },
                child: Text(
                  isExpanded ? LocaleKeys.showLess : LocaleKeys.showMore,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getTrimmedText(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: widget.trimLines,
    )..layout(maxWidth: maxWidth);

    if (!textPainter.didExceedMaxLines) return text;

    final lines = textPainter.computeLineMetrics();
    if (lines.isEmpty) return text;

    final lastVisibleLine = lines[widget.trimLines - 1];

    final endOffset = textPainter
        .getPositionForOffset(
          Offset(lastVisibleLine.width, lastVisibleLine.baseline),
        )
        .offset;

    var trimmed = text.substring(0, endOffset);

    final lastSpace = trimmed.lastIndexOf(' ');
    if (lastSpace != -1) {
      trimmed = trimmed.substring(0, lastSpace);
    }

    return '$trimmed...';
  }
}
