import 'package:get_it/get_it.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/contractor_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/user_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo_impl.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo_impl.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart/auth_cubit.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';

// dependency injection
final GetIt getIt = GetIt.instance;

class ServiceLocator {
  void init() {
    getIt.registerSingleton<AppRouter>(AppRouter());
    getIt.registerLazySingleton<DioHelper>(() => DioHelper());
    getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());

    getIt.registerLazySingleton<UserAuthDataSource>(
      () => UserAuthDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<UserAuthRepo>(
      () => UserAuthRepoImpl(userAuthDataSource: getIt<UserAuthDataSource>()),
    );
    getIt.registerLazySingleton<ContractorAuthDataSource>(
      () => ContractorAuthDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<ContractorAuthRepo>(
      () => ContractorAuthRepoImpl(contractorAuthDataSource: getIt<ContractorAuthDataSource>()),
    );
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        userAuthRepoImpl: getIt<UserAuthRepo>(),
        cacheHelper: getIt<CacheHelper>(),
        contractorAuthRepoImpl: getIt<ContractorAuthRepo>(),
      ),
    );
    getIt.registerFactory<AppCubit>(
      () => AppCubit(userAuthRepo: getIt<UserAuthRepo>()),
    );
  }
}
