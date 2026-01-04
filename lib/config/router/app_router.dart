import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
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
import 'package:mokawlcom_app/features/home/presentation/company_details_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/home_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/job_details_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/job_offers_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/services_details_screen.dart';
import 'package:mokawlcom_app/features/home/presentation/services_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/notifications_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/offer_details_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/price_offers_screen.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/public_notifications_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/add_new_service_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/available_deals_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/change_password_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/edit_contractor_profile_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/edit_user_profile_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/my_current_package_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/my_services_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/profile_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/send_offer_to_contractors_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/saved_companies_screen.dart';
import 'package:mokawlcom_app/features/profile/presentation/submitted_price_offers_screen.dart';
import 'package:mokawlcom_app/features/splash/on_boarding_screen.dart';
import 'package:mokawlcom_app/features/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  AppRouter() : super(navigatorKey: rootNavigatorKey);

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: SplashTabRoute.page,
      children: [
        AutoRoute(initial: true, page: SplashRoute.page),
        _buildCustomRoute(page: OnBoardingRoute.page),
      ],
    ),
    _buildCustomRoute(
      page: AuthRoute.page,
      children: [
        _buildCustomRoute(initial: true, page: LoginRoute.page),
        _buildCustomRoute(page: UserSignupRoute.page),
        _buildCustomRoute(page: ContractorSignupRoute.page),
        _buildCustomRoute(page: ClassificationRoute.page),
        _buildCustomRoute(page: SelectServicesRoute.page),
        _buildCustomRoute(page: ForgetPasswordRoute.page),
        _buildCustomRoute(page: VerificationRoute.page),
        _buildCustomRoute(page: UploadFilesRoute.page),
        _buildCustomRoute(page: SubscriptionRoute.page),
        _buildCustomRoute(page: CompleteDataRoute.page),
      ],
    ),
    _buildCustomRoute(
      page: AuthenticatedRoute.page,
      children: [
        _buildCustomRoute(
          initial: true,
          page: BottomNavBarRoute.page,
          children: [
            _buildCustomRoute(
              initial: true,
              page: HomeTabRoute.page,
              children: [
                _buildCustomRoute(initial: true, page: HomeRoute.page),
                _buildCustomRoute(page: ServicesRoute.page),
                _buildCustomRoute(page: JobOffersRoute.page),
              ],
            ),
            _buildCustomRoute(
              page: NotificationsRoute.page,
              children: [
                _buildCustomRoute(
                  initial: true,
                  page: PublicNotificationsRoute.page,
                ),
                _buildCustomRoute(page: PriceOffersRoute.page),
              ],
            ),
            _buildCustomRoute(page: ProfileRoute.page),
          ],
        ),
        _buildCustomRoute(
          page: JobDetailsRoute.page,
          children: [
            _buildCustomRoute(initial: true, page: CompanyDetailsRoute.page),
            _buildCustomRoute(page: ServicesDetailsRoute.page),
          ],
        ),
        _buildCustomRoute(page: OfferDetailsRoute.page),
        _buildCustomRoute(page: ChangePasswordRoute.page),
        _buildCustomRoute(page: EditUserProfileRoute.page),
        _buildCustomRoute(page: EditContractorProfileRoute.page),
        _buildCustomRoute(page: MyServicesRoute.page),
        _buildCustomRoute(page: AddNewServiceRoute.page),
        _buildCustomRoute(page: MyCurrentPackageRoute.page),
        _buildCustomRoute(page: AvailableDealsRoute.page),
        _buildCustomRoute(page: SendOfferToContractorsRoute.page),
        _buildCustomRoute(page: SubmittedPriceOffersRoute.page),
        _buildCustomRoute(page: SavedCompaniesRoute.page),
      ],
    ),
  ];

  CustomRoute _buildCustomRoute({
    bool initial = false,
    required PageInfo page,
    List<AutoRoute>? children,
  }) {
    return CustomRoute(
      initial: initial,
      page: page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: const Duration(milliseconds: 300),
      children: children,
    );
  }
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
    providers: [BlocProvider(create: (context) => getIt<AuthCubit>())],
    child: this,
  );
}

@RoutePage(name: 'HomeTabRoute')
class HomeTab extends AutoRouter {
  const HomeTab({super.key});
}

@RoutePage(name: 'AuthenticatedRoute')
class Authenticated extends AutoRouter {
  const Authenticated({super.key});
}
