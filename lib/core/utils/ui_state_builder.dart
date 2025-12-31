// import 'package:flutter/material.dart';
// import 'package:mokawlcom_app/core/enums/request_status.dart';
// import 'package:mokawlcom_app/core/utils/state_box.dart';

// class UiStateBuilder extends StatelessWidget {
//   final StateBox state;
//   final Widget onInitial;
//   final Widget onLoading; 
//   final Widget onSuccess;
//   final Widget onError;
//   final bool isConnected;

//   const UiStateBuilder({
//     super.key,
//     required this.state,
//     required this.onInitial,
//     required this.onLoading,
//     required this.onSuccess,
//     required this.onError,
//     this.isConnected = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return switch (state.requestState) {
//       RequestStatus.initial => onInitial,
//       RequestStatus.loading => onLoading,
//       RequestStatus.success => onSuccess,
//       RequestStatus.error =>
//         isConnected
//             ? onError
//             : NoInternetWidget(errorMessage: state.errorMessage),
//     };
//   }
// }
