import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mokawlcom_app/core/local/shared_pref_helper.dart';

class CacheHelper {
  final SharedPrefHelper sharedPrefHelper;
  final FlutterSecureStorage _flutterSecureStorage;

  CacheHelper({
    required this.sharedPrefHelper,
  })
    : _flutterSecureStorage = FlutterSecureStorage(
        aOptions: _getAndroidOptions(),
      );

  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions();

  Future<void> saveData({required String key, required String value}) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> readData({required String key}) async {
    return await _flutterSecureStorage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _flutterSecureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }
  Future<void> setOnBoardingSeen() async {
    await sharedPrefHelper.setBool("on_boarding", true);
  }

  bool isOnBoardingSeen() {
    return sharedPrefHelper.getBool("on_boarding") ?? false;
  }
}
