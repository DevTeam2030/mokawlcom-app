import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/classification_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/complete_data_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/contractor_signup_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/login_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/select_services_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/subscription_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/upload_files_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/user_signup_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/verification_screen.dart';
import 'package:mokawlcom_app/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_cubit.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_bloc/search_bloc.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/company_details_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/home_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/contractor_details_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/contractors_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/services_details_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/services_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/notifications_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/offer_details_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/price_offers_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/public_notifications_screen.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/add_new_service_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/available_deals_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/edit_contractor_profile_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/edit_deal_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/edit_service_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/edit_user_profile_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/my_current_package_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/my_services_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/send_offer_to_contractors_screen.dart';
import 'package:mokawlcom_app/features/favorite/presentation/screens/saved_companies_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/submitted_price_offers_screen.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/features/splash/on_boarding_screen.dart';
import 'package:mokawlcom_app/features/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: rootNavigatorKey);

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: SplashTabRoute.page,
      children: [
        AutoRoute(initial: true, page: SplashRoute.page),
        AutoRoute(page: OnBoardingRoute.page),
      ],
    ),
    AutoRoute(
      page: AuthRoute.page,
      children: [
        AutoRoute(initial: true, page: LoginRoute.page),
        AutoRoute(page: UserSignupRoute.page),
        AutoRoute(page: ContractorSignupRoute.page),
        AutoRoute(page: ClassificationRoute.page),
        AutoRoute(page: SelectServicesRoute.page),
        AutoRoute(page: ForgetPasswordRoute.page),
        AutoRoute(page: VerificationRoute.page),
        AutoRoute(page: UploadFilesRoute.page),
        AutoRoute(page: SubscriptionRoute.page),
        AutoRoute(page: CompleteDataRoute.page),
      ],
    ),
    AutoRoute(
      page: AuthenticatedRoute.page,
      children: [
        AutoRoute(
          initial: true,
          page: BottomNavBarRoute.page,
          children: [
            AutoRoute(
              initial: true,
              
              page: HomeTabRoute.page,
              children: [
                AutoRoute(initial: true, page: HomeRoute.page),
                AutoRoute(page: ServicesRoute.page),
                AutoRoute(page: ContractorsRoute.page),
              ],
            ),
            AutoRoute(
              page: NotificationsRoute.page,
              children: [
                AutoRoute(initial: true, page: PublicNotificationsRoute.page),
                AutoRoute(page: PriceOffersRoute.page),
              ],
            ),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
        AutoRoute(
          page: ContractorDetailsRoute.page,
          children: [
            AutoRoute(initial: true, page: CompanyDetailsRoute.page),
            AutoRoute(page: ServicesDetailsRoute.page),
          ],
        ),
        AutoRoute(page: OfferDetailsRoute.page),
        AutoRoute(page: ChangePasswordRoute.page),
        AutoRoute(page: EditUserProfileRoute.page),
        AutoRoute(page: EditContractorProfileRoute.page),
        AutoRoute(page: MyServicesRoute.page),
        AutoRoute(page: AddNewServiceRoute.page),
        AutoRoute(page: MyCurrentPackageRoute.page),
        AutoRoute(page: AvailableDealsRoute.page),
        AutoRoute(page: SendOfferToContractorsRoute.page),
        AutoRoute(page: SubmittedPriceOffersRoute.page),
        AutoRoute(page: SavedCompaniesRoute.page),
        AutoRoute(page: EditDealRoute.page),
        AutoRoute(page: EditServiceRoute.page),
      ],
    ),
  ];
}

@RoutePage(name: 'SplashTabRoute')
class Splash extends AutoRouter {
  const Splash({super.key});
}

@RoutePage(name: 'AuthRoute')
class Auth extends AutoRouter implements AutoRouteWrapper {
  const Auth({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<AuthCubit>()),
      BlocProvider(create: (context) => getIt<FilesCubit>()),
    ],
    child: this,
  );
}

@RoutePage(name: 'HomeTabRoute')
class HomeTab extends AutoRouter {
  const HomeTab({super.key});
}

@RoutePage(name: 'AuthenticatedRoute')
class Authenticated extends AutoRouter implements AutoRouteWrapper {
  const Authenticated({super.key});
  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<HomeCubit>()),
      BlocProvider(create: (context) => getIt<SearchBloc>()),
      BlocProvider(
        create: (context) => getIt<NotificationsCubit>(),
      
      ),
     
    ],
    child: this,
  );
}
