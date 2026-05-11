// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:mokawlcom_app/config/router/app_router.dart';

// OverlayEntry? _toastOverlay;

// Future<void> showToast({
//   required String message,
//   required ToastStates state,
//   Duration duration = const Duration(seconds: 5),
// }) async {
//   _toastOverlay?.remove();

//   final navigatorContext =
//       AppRouter.rootNavigatorKey.currentContext;

//   if (navigatorContext == null) return;

//   final overlayState =
//       Navigator.of(navigatorContext, rootNavigator: true).overlay;

//   if (overlayState == null) return;

//   final Color bgColor;
//   switch (state) {
//     case ToastStates.success:
//       bgColor = Colors.green;
//       break;
//     case ToastStates.error:
//       bgColor = Colors.red;
//       break;
//     case ToastStates.warning:
//       bgColor = Colors.orange;
//       break;
//   }

//   _toastOverlay = OverlayEntry(
//     builder: (_) => PositionedDirectional(
//       bottom: 50,
//       start: 30,
//       end: 30,
//       child: Material(
//         color: Colors.transparent,
//         child: Container(
//           padding: const EdgeInsetsDirectional.symmetric(
//             horizontal: 20,
//             vertical: 20,
//           ),
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.2),
//                 blurRadius: 6,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Align(
//             alignment: AlignmentDirectional.centerStart,
//             child: Text(
//               message,
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

//   overlayState.insert(_toastOverlay!);

//   await Future.delayed(duration);
//   _toastOverlay?.remove();
//   _toastOverlay = null;
// }

// enum ToastStates { success, error, warning }
