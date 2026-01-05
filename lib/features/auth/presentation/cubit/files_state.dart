import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';

class FilesState extends Equatable {
  final RequestStatus uploadFileState;
  final double progress;
  final String errorMessage;
  final String successMessage;
  final Set<int> completedFiles;
  final File? selectedFile;
  final bool isFileLoading;

  const FilesState({
    this.uploadFileState = RequestStatus.initial,
    this.progress = 0,
    this.errorMessage = "",
    this.successMessage = "",
    this.completedFiles = const {},
    this.selectedFile,
    this.isFileLoading = false,
  });

  FilesState copyWith({
    RequestStatus? uploadFileState,
    double? progress,
    String? errorMessage,
    String? successMessage,
    Set<int>? completedFiles,
    File? selectedFile,
    bool? isFileLoading,
  }) {
    return FilesState(
      uploadFileState: uploadFileState ?? this.uploadFileState,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      completedFiles: completedFiles ?? this.completedFiles,
      selectedFile: selectedFile ?? this.selectedFile,
      isFileLoading: isFileLoading ?? this.isFileLoading,
    );
  }

  @override
  List<Object?> get props => [
    uploadFileState,
    progress,
    errorMessage,
    successMessage,
    completedFiles,
    selectedFile,
    isFileLoading,
  ];
}
