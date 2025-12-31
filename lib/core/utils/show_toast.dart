import 'package:flutter/material.dart';

Future<void> showToast({
  required BuildContext context,
  required String message,
  required ToastStates state,
}) async {
  final Color bgColor;
  switch (state) {
    case ToastStates.success:
      bgColor = Colors.green;
      break;
    case ToastStates.error:
      bgColor = Colors.red;
      break;
    case ToastStates.warning:
      bgColor = Colors.orange;
      break;

  }

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => PositionedDirectional(
      bottom: 50,
      start: 30,
      end: 30,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0,vertical: 20.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.4,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  await Future.delayed(const Duration(seconds: 5));
  overlayEntry.remove();
}

enum ToastStates { success, error, warning }
