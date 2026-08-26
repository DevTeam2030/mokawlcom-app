import 'package:mokawlcom_app/core/utils/locale_keys.dart';

String? validateRequiredDealField(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName ${LocaleKeys.required}';
  }
  return null;
}
