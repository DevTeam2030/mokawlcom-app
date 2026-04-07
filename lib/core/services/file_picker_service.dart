import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:localingo/localingo.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';


class FilePickerService {
  static const int maxFileSizeInMB = 10;
  static const int maxImagesCount = 5;

  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    final file = File(result.files.single.path!);
    final sizeInMB = file.lengthSync() / (1024 * 1024);

    if (sizeInMB > maxFileSizeInMB) {
      throw FileSizeException(
        LocaleKeys.fileSizeMustBeLessThan.replaceAll(
          '{}',
          maxFileSizeInMB.toString(),
        ),
      );
    }

    return file;
  }

}

class FileSizeException implements Exception {
  final String message;

  FileSizeException(this.message);

  @override
  String toString() => message;
}