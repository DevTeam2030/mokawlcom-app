import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo_impl.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final ContractorAuthRepo contractorAuthRepoImpl;
  FilesCubit({required this.contractorAuthRepoImpl})
    : super(const FilesState());
  void initUploadFile() => emit(state.copyWith(
    // ignore: avoid_redundant_argument_values
    selectedFile: null,
    progress: 0,
  ));
  Future<void> pickFile() async {
    emit(state.copyWith(isFileLoading: true));
    try {
      final file = await FilePickerService.pickFile();
      emit(state.copyWith(selectedFile: file, isFileLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isFileLoading: false,
          errorMessage: e.toString(),
          uploadFileState: RequestStatus.error,
        ),
      );
    }
  }

  Future<void> uploadCommercialRegistry({
    required int index,
    required int contractorId,
    required String fileNumber,
    required String expiryDate,
  }) async {
    if (state.selectedFile == null) {
      emit(
        state.copyWith(
          errorMessage: "No file selected",
          uploadFileState: RequestStatus.error,
        ),
      );
      return;
    }
    emit(state.copyWith(uploadFileState: RequestStatus.loading));

    UploadFileModel fileModel = UploadFileModel(
      file: state.selectedFile!,
      userId: contractorId,
      fileNumber: fileNumber,
      expiryDate: expiryDate,
    );
    final result = await contractorAuthRepoImpl.uploadCommercialRegistry(
      fileModel: fileModel,
      onProgress: (progress) => emit(state.copyWith(progress: progress)),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) {
        Set<int> completedFiles = {...state.completedFiles};
        completedFiles.add(index);
        emit(
          state.copyWith(
            uploadFileState: RequestStatus.success,
            successMessage: message,
            completedFiles: completedFiles,
            // ignore: avoid_redundant_argument_values
            selectedFile: null,
            progress: 0,
          ),
        );
      },
    );
  }
}
