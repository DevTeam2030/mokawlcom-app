
import 'package:get_it/get_it.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';

// dependency injection
final GetIt getIt = GetIt.instance;

class ServiceLocator {
  void init() {
    getIt.registerSingleton<AppRouter>(AppRouter());

  }
}
