import 'package:get_it/get_it.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/local/shared_pref_helper.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/contractor_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/user_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo_impl.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo_impl.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_cubit.dart';
import 'package:mokawlcom_app/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_cubit.dart';
import 'package:mokawlcom_app/features/favorite/repo/favorite_repo.dart';
import 'package:mokawlcom_app/features/favorite/repo/favorite_repo_impl.dart';
import 'package:mokawlcom_app/features/home/data/data_source/home_data_source.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo_impl.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/data/data_source/notifications_data_source.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notifications_repo.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notificatons_repo_impl.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/profile/data/data_source/profile_data_source.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo_impl.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';

// dependency injection
final GetIt getIt = GetIt.instance;

class ServiceLocator {
  void init({
    required SharedPrefHelper sharedPrefHelper,
    required CacheHelper cacheHelper,
  }) {
    getIt.registerSingleton<SharedPrefHelper>(sharedPrefHelper);
    getIt.registerSingleton<CacheHelper>(cacheHelper);
    getIt.registerSingleton<AppRouter>(AppRouter());

    getIt.registerLazySingleton<DioHelper>(() => DioHelper());
    getIt.registerLazySingleton<FilePickerService>(() => FilePickerService());

    getIt.registerLazySingleton<UserAuthDataSource>(
      () => UserAuthDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<ContractorAuthDataSource>(
      () => ContractorAuthDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<HomeDataSource>(
      () => HomeDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<NotificationsDataSource>(
      () => NotificationsDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<FavoriteDataSource>(
      () => FavoriteDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );
    getIt.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSourceImpl(dioHelper: getIt<DioHelper>()),
    );

    getIt.registerLazySingleton<UserAuthRepo>(
      () => UserAuthRepoImpl(userAuthDataSource: getIt<UserAuthDataSource>()),
    );
    getIt.registerLazySingleton<ContractorAuthRepo>(
      () => ContractorAuthRepoImpl(
        contractorAuthDataSource: getIt<ContractorAuthDataSource>(),
      ),
    );
    getIt.registerLazySingleton<HomeRepo>(
      () => HomeRepoImpl(homeDataSource: getIt<HomeDataSource>()),
    );
    getIt.registerLazySingleton<NotificationsRepo>(
      () => NotificationsRepoImpl(
        notificationsDataSource: getIt<NotificationsDataSource>(),
      ),
    );
    getIt.registerLazySingleton<FavoriteRepo>(
      () => FavoriteRepoImpl(favoriteDataSource: getIt<FavoriteDataSource>()),
    );
    getIt.registerLazySingleton<ProfileRepo>(
      () => ProfileRepoImpl(profileDataSource: getIt<ProfileDataSource>()),
    );

    getIt.registerFactory<AppCubit>(
      () => AppCubit(userAuthRepo: getIt<UserAuthRepo>()),
    );
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        userAuthRepoImpl: getIt<UserAuthRepo>(),
        cacheHelper: getIt<CacheHelper>(),
        contractorAuthRepoImpl: getIt<ContractorAuthRepo>(),
      ),
    );
    getIt.registerFactory<FilesCubit>(
      () => FilesCubit(contractorAuthRepoImpl: getIt<ContractorAuthRepo>()),
    );
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(
        contractorAuthRepoImpl: getIt<ContractorAuthRepo>(),
        homeRepoImpl: getIt<HomeRepo>(),
      ),
    );
    getIt.registerFactory<SearchCubit>(
      () => SearchCubit(homeRepoImpl: getIt<HomeRepo>()),
    );
    getIt.registerFactory(
      () => ContractorInfoCubit(homeRepo: getIt<HomeRepo>()),
    );
    getIt.registerFactory<FavoriteCubit>(
      () => FavoriteCubit(favoriteRepo: getIt<FavoriteRepo>()),
    );
    getIt.registerFactory<NotificationsCubit>(
      () => NotificationsCubit(notificationsRepo: getIt<NotificationsRepo>()),
    );
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        profileRepo: getIt<ProfileRepo>(),
        cacheHelper: getIt<CacheHelper>(),
      ),
    );
    getIt.registerFactory<UserDetailsCubit>(
      () => UserDetailsCubit(profileRepo: getIt<ProfileRepo>()),
    );
  }
}
