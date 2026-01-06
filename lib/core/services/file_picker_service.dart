import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static const int maxFileSizeInMB = 10;

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
      throw Exception('File size must be less than ${maxFileSizeInMB}MB');
    }

    return file;
  }
}
