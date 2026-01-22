import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:localingo/localingo.dart';
import 'package:mokawlcom_app/locale_keys.dart';



class ImagePickerService {
  static const int maxImageSizeInMB = 10;
  static const int maxImagesCount = 5;

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90, 
    );

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final sizeInMB = file.lengthSync() / (1024 * 1024);

    if (sizeInMB > maxImageSizeInMB) {
      throw Exception(
        LocaleKeys.fileSizeMustBeLessThan.replaceAll(
          '{}',
          maxImageSizeInMB.toString(),
        ),
      );
    }

    return file;
  }

  static Future<List<File>> pickMultipleImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 90, 
    );

    if (pickedFiles.isEmpty) return [];

    final validImages = <File>[];

    for (final picked in pickedFiles) {
      final file = File(picked.path);
      final sizeInMB = file.lengthSync() / (1024 * 1024);

      if (sizeInMB > maxImageSizeInMB) {
        throw Exception(
          LocaleKeys.fileSizeMustBeLessThan.replaceAll(
            '{}',
            maxImageSizeInMB.toString(),
          ),
        );
      }

      validImages.add(file);
      if (validImages.length == maxImagesCount) break;
    }

    return validImages;
  }
}
