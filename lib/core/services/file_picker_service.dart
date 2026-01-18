import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:localingo/localingo.dart';

import '../../locale_keys.dart';

class FilePickerService {
  static const int maxFileSizeInMB = 10;
  static const int maxImagesCount = 5;

  static Future<File?> pickFile({bool image = false}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: image
          ? ['jpg', 'jpeg', 'png']
          : ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    final file = File(result.files.single.path!);
    final sizeInMB = file.lengthSync() / (1024 * 1024);

    if (sizeInMB > maxFileSizeInMB) {
      throw Exception(
        LocaleKeys.fileSizeMustBeLessThan.tr().replaceAll(
          '{}',
          maxFileSizeInMB.toString(),
        ),
      );
    }

    return file;
  }

  static Future<List<File>> pickMultipleImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result == null) return [];

    final validImages = <File>[];

    for (final path in result.paths) {
      if (path == null) continue;

      final file = File(path);
      final sizeInMB = file.lengthSync() / (1024 * 1024);

      if (sizeInMB > maxFileSizeInMB) {
        throw Exception(
          LocaleKeys.fileSizeMustBeLessThan.tr().replaceAll(
            '{}',
            maxFileSizeInMB.toString(),
          ),
        );
      }

      validImages.add(file);

      if (validImages.length == maxImagesCount) break;
    }

    return validImages;
  }
}
