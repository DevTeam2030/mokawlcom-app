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

  void clearOldFile() => emit(state.copyWith(clearSelectedFile: true));

  Future<void> pickFile() async {
    emit(state.copyWith(isFileLoading: true));
    try {
      final File? file = await FilePickerService.pickFile();
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
    if (state.uploadFileState.isLoading) return;
    if (state.selectedFile == null) {
      emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: "Please select a file first",
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
      onProgress: (progress) {
        emit(state.copyWith(progress: progress));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          progress: 0,
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
            progress: 0,
          ),
        );
      },
    );
  }

  Future<void> uploadTradeLicense({
    required int index,
    required int contractorId,
    required String fileNumber,
    required String expiryDate,
  }) async {
    if (state.uploadFileState.isLoading) return;
    if (state.selectedFile == null) {
      emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: "Please select a file first",
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
    final result = await contractorAuthRepoImpl.uploadTradeLicense(
      fileModel: fileModel,
      onProgress: (progress) {
        emit(state.copyWith(progress: progress));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          progress: 0,
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
            progress: 0,
          ),
        );
      },
    );
  }

  Future<void> uploadEstablishmentCertificate({
    required int index,
    required int contractorId,
    required String fileNumber,
    required String expiryDate,
  }) async {
    if (state.uploadFileState.isLoading) return;
    if (state.selectedFile == null) {
      emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: "Please select a file first",
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
    final result = await contractorAuthRepoImpl.uploadEstablishmentCertificate(
      fileModel: fileModel,
      onProgress: (progress) {
        emit(state.copyWith(progress: progress));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          progress: 0,
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
            progress: 0,
          ),
        );
      },
    );
  }

  Future<void> uploadAuthorizedSignature({
    required int index,
    required int contractorId,
    required String fileNumber,
    required String expiryDate,
  }) async {
    if (state.uploadFileState.isLoading) return;
    if (state.selectedFile == null) {
      emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: "Please select a file first",
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
    final result = await contractorAuthRepoImpl.uploadAuthorizedSignature(
      fileModel: fileModel,
      onProgress: (progress) {
        emit(state.copyWith(progress: progress));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          uploadFileState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          progress: 0,
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
            progress: 0,
          ),
        );
      },
    );
  }
}
