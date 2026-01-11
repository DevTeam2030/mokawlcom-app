import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final int trimLines;
  final Color color;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.color = ColorsManager.primaryColor,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: theme.textTheme.bodySmall!.copyWith(
            color: widget.color,
            height: 1.5,
          ),
          maxLines: isExpanded ? null : widget.trimLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
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
  }
}
