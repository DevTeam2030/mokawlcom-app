import 'package:get_it/get_it.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/features/auth/data/user/data_source/user_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo_impl.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/user_auth_cubit.dart/user_auth_cubit.dart';

// dependency injection
final GetIt getIt = GetIt.instance;

class ServiceLocator {
  void init() {
    getIt.registerSingleton<AppRouter>(AppRouter());
    getIt.registerLazySingleton<DioHelper>(() => DioHelper());
    getIt.registerLazySingleton<UserAuthDataSource>(
      () => UserAuthDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<UserAuthRepo>(
      () => UserAuthRepoImpl(userAuthDataSource: getIt<UserAuthDataSource>()),
    );
    getIt.registerFactory<UserAuthCubit>(
      () => UserAuthCubit(userAuthRepoImpl: getIt<UserAuthRepo>()),
    );
  }
}
