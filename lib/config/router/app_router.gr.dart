// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddNewServiceScreen]
class AddNewServiceRoute extends PageRouteInfo<AddNewServiceRouteArgs> {
  AddNewServiceRoute({
    Key? key,
    required ThemeData theme,
    List<PageRouteInfo>? children,
  }) : super(
         AddNewServiceRoute.name,
         args: AddNewServiceRouteArgs(key: key, theme: theme),
         initialChildren: children,
       );

  static const String name = 'AddNewServiceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddNewServiceRouteArgs>();
      return AddNewServiceScreen(key: args.key, theme: args.theme);
    },
  );
}

class AddNewServiceRouteArgs {
  const AddNewServiceRouteArgs({this.key, required this.theme});

  final Key? key;

  final ThemeData theme;

  @override
  String toString() {
    return 'AddNewServiceRouteArgs{key: $key, theme: $theme}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddNewServiceRouteArgs) return false;
    return key == other.key && theme == other.theme;
  }

  @override
  int get hashCode => key.hashCode ^ theme.hashCode;
}

/// generated route for
/// [Auth]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const Auth());
    },
  );
}

/// generated route for
/// [Authenticated]
class AuthenticatedRoute extends PageRouteInfo<void> {
  const AuthenticatedRoute({List<PageRouteInfo>? children})
    : super(AuthenticatedRoute.name, initialChildren: children);

  static const String name = 'AuthenticatedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const Authenticated());
    },
  );
}

/// generated route for
/// [AvailableDealsScreen]
class AvailableDealsRoute extends PageRouteInfo<void> {
  const AvailableDealsRoute({List<PageRouteInfo>? children})
    : super(AvailableDealsRoute.name, initialChildren: children);

  static const String name = 'AvailableDealsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AvailableDealsScreen();
    },
  );
}

/// generated route for
/// [BottomNavBarScreen]
class BottomNavBarRoute extends PageRouteInfo<void> {
  const BottomNavBarRoute({List<PageRouteInfo>? children})
    : super(BottomNavBarRoute.name, initialChildren: children);

  static const String name = 'BottomNavBarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BottomNavBarScreen();
    },
  );
}

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [ClassificationScreen]
class ClassificationRoute extends PageRouteInfo<void> {
  const ClassificationRoute({List<PageRouteInfo>? children})
    : super(ClassificationRoute.name, initialChildren: children);

  static const String name = 'ClassificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClassificationScreen();
    },
  );
}

/// generated route for
/// [CompanyDetailsScreen]
class CompanyDetailsRoute extends PageRouteInfo<void> {
  const CompanyDetailsRoute({List<PageRouteInfo>? children})
    : super(CompanyDetailsRoute.name, initialChildren: children);

  static const String name = 'CompanyDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CompanyDetailsScreen();
    },
  );
}

/// generated route for
/// [CompleteDataScreen]
class CompleteDataRoute extends PageRouteInfo<void> {
  const CompleteDataRoute({List<PageRouteInfo>? children})
    : super(CompleteDataRoute.name, initialChildren: children);

  static const String name = 'CompleteDataRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CompleteDataScreen();
    },
  );
}

/// generated route for
/// [ContractorDetailsScreen]
class ContractorDetailsRoute extends PageRouteInfo<ContractorDetailsRouteArgs> {
  ContractorDetailsRoute({
    Key? key,
    bool isOfferrice = false,
    required int contractorId,
    List<PageRouteInfo>? children,
  }) : super(
         ContractorDetailsRoute.name,
         args: ContractorDetailsRouteArgs(
           key: key,
           isOfferrice: isOfferrice,
           contractorId: contractorId,
         ),
         initialChildren: children,
       );

  static const String name = 'ContractorDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContractorDetailsRouteArgs>();
      return WrappedRoute(
        child: ContractorDetailsScreen(
          key: args.key,
          isOfferrice: args.isOfferrice,
          contractorId: args.contractorId,
        ),
      );
    },
  );
}

class ContractorDetailsRouteArgs {
  const ContractorDetailsRouteArgs({
    this.key,
    this.isOfferrice = false,
    required this.contractorId,
  });

  final Key? key;

  final bool isOfferrice;

  final int contractorId;

  @override
  String toString() {
    return 'ContractorDetailsRouteArgs{key: $key, isOfferrice: $isOfferrice, contractorId: $contractorId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContractorDetailsRouteArgs) return false;
    return key == other.key &&
        isOfferrice == other.isOfferrice &&
        contractorId == other.contractorId;
  }

  @override
  int get hashCode =>
      key.hashCode ^ isOfferrice.hashCode ^ contractorId.hashCode;
}

/// generated route for
/// [ContractorSignupScreen]
class ContractorSignupRoute extends PageRouteInfo<void> {
  const ContractorSignupRoute({List<PageRouteInfo>? children})
    : super(ContractorSignupRoute.name, initialChildren: children);

  static const String name = 'ContractorSignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContractorSignupScreen();
    },
  );
}

/// generated route for
/// [ContractorsScreen]
class ContractorsRoute extends PageRouteInfo<ContractorsRouteArgs> {
  ContractorsRoute({
    Key? key,
    ClassificationModel? classificationModel,
    ServiceModel? serviceModel,
    bool fromSearch = false,
    List<PageRouteInfo>? children,
  }) : super(
         ContractorsRoute.name,
         args: ContractorsRouteArgs(
           key: key,
           classificationModel: classificationModel,
           serviceModel: serviceModel,
           fromSearch: fromSearch,
         ),
         initialChildren: children,
       );

  static const String name = 'ContractorsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContractorsRouteArgs>(
        orElse: () => const ContractorsRouteArgs(),
      );
      return ContractorsScreen(
        key: args.key,
        classificationModel: args.classificationModel,
        serviceModel: args.serviceModel,
        fromSearch: args.fromSearch,
      );
    },
  );
}

class ContractorsRouteArgs {
  const ContractorsRouteArgs({
    this.key,
    this.classificationModel,
    this.serviceModel,
    this.fromSearch = false,
  });

  final Key? key;

  final ClassificationModel? classificationModel;

  final ServiceModel? serviceModel;

  final bool fromSearch;

  @override
  String toString() {
    return 'ContractorsRouteArgs{key: $key, classificationModel: $classificationModel, serviceModel: $serviceModel, fromSearch: $fromSearch}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContractorsRouteArgs) return false;
    return key == other.key &&
        classificationModel == other.classificationModel &&
        serviceModel == other.serviceModel &&
        fromSearch == other.fromSearch;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      classificationModel.hashCode ^
      serviceModel.hashCode ^
      fromSearch.hashCode;
}

/// generated route for
/// [EditContractorProfileScreen]
class EditContractorProfileRoute extends PageRouteInfo<void> {
  const EditContractorProfileRoute({List<PageRouteInfo>? children})
    : super(EditContractorProfileRoute.name, initialChildren: children);

  static const String name = 'EditContractorProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditContractorProfileScreen();
    },
  );
}

/// generated route for
/// [EditUserProfileScreen]
class EditUserProfileRoute extends PageRouteInfo<void> {
  const EditUserProfileRoute({List<PageRouteInfo>? children})
    : super(EditUserProfileRoute.name, initialChildren: children);

  static const String name = 'EditUserProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditUserProfileScreen();
    },
  );
}

/// generated route for
/// [ForgetPasswordScreen]
class ForgetPasswordRoute extends PageRouteInfo<void> {
  const ForgetPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgetPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgetPasswordScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [HomeTab]
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
    : super(HomeTabRoute.name, initialChildren: children);

  static const String name = 'HomeTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeTab();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MyCurrentPackageScreen]
class MyCurrentPackageRoute extends PageRouteInfo<void> {
  const MyCurrentPackageRoute({List<PageRouteInfo>? children})
    : super(MyCurrentPackageRoute.name, initialChildren: children);

  static const String name = 'MyCurrentPackageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyCurrentPackageScreen();
    },
  );
}

/// generated route for
/// [MyServicesScreen]
class MyServicesRoute extends PageRouteInfo<void> {
  const MyServicesRoute({List<PageRouteInfo>? children})
    : super(MyServicesRoute.name, initialChildren: children);

  static const String name = 'MyServicesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyServicesScreen();
    },
  );
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationsScreen();
    },
  );
}

/// generated route for
/// [OfferDetailsScreen]
class OfferDetailsRoute extends PageRouteInfo<void> {
  const OfferDetailsRoute({List<PageRouteInfo>? children})
    : super(OfferDetailsRoute.name, initialChildren: children);

  static const String name = 'OfferDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OfferDetailsScreen();
    },
  );
}

/// generated route for
/// [OnBoardingScreen]
class OnBoardingRoute extends PageRouteInfo<void> {
  const OnBoardingRoute({List<PageRouteInfo>? children})
    : super(OnBoardingRoute.name, initialChildren: children);

  static const String name = 'OnBoardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnBoardingScreen();
    },
  );
}

/// generated route for
/// [PriceOffersScreen]
class PriceOffersRoute extends PageRouteInfo<void> {
  const PriceOffersRoute({List<PageRouteInfo>? children})
    : super(PriceOffersRoute.name, initialChildren: children);

  static const String name = 'PriceOffersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PriceOffersScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [PublicNotificationsScreen]
class PublicNotificationsRoute extends PageRouteInfo<void> {
  const PublicNotificationsRoute({List<PageRouteInfo>? children})
    : super(PublicNotificationsRoute.name, initialChildren: children);

  static const String name = 'PublicNotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PublicNotificationsScreen();
    },
  );
}

/// generated route for
/// [SavedCompaniesScreen]
class SavedCompaniesRoute extends PageRouteInfo<void> {
  const SavedCompaniesRoute({List<PageRouteInfo>? children})
    : super(SavedCompaniesRoute.name, initialChildren: children);

  static const String name = 'SavedCompaniesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SavedCompaniesScreen();
    },
  );
}

/// generated route for
/// [SelectServicesScreen]
class SelectServicesRoute extends PageRouteInfo<SelectServicesRouteArgs> {
  SelectServicesRoute({
    Key? key,
    required int classificationId,
    List<PageRouteInfo>? children,
  }) : super(
         SelectServicesRoute.name,
         args: SelectServicesRouteArgs(
           key: key,
           classificationId: classificationId,
         ),
         initialChildren: children,
       );

  static const String name = 'SelectServicesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectServicesRouteArgs>();
      return SelectServicesScreen(
        key: args.key,
        classificationId: args.classificationId,
      );
    },
  );
}

class SelectServicesRouteArgs {
  const SelectServicesRouteArgs({this.key, required this.classificationId});

  final Key? key;

  final int classificationId;

  @override
  String toString() {
    return 'SelectServicesRouteArgs{key: $key, classificationId: $classificationId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelectServicesRouteArgs) return false;
    return key == other.key && classificationId == other.classificationId;
  }

  @override
  int get hashCode => key.hashCode ^ classificationId.hashCode;
}

/// generated route for
/// [SendOfferToContractorsScreen]
class SendOfferToContractorsRoute extends PageRouteInfo<void> {
  const SendOfferToContractorsRoute({List<PageRouteInfo>? children})
    : super(SendOfferToContractorsRoute.name, initialChildren: children);

  static const String name = 'SendOfferToContractorsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SendOfferToContractorsScreen();
    },
  );
}

/// generated route for
/// [ServicesDetailsScreen]
class ServicesDetailsRoute extends PageRouteInfo<void> {
  const ServicesDetailsRoute({List<PageRouteInfo>? children})
    : super(ServicesDetailsRoute.name, initialChildren: children);

  static const String name = 'ServicesDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ServicesDetailsScreen();
    },
  );
}

/// generated route for
/// [ServicesScreen]
class ServicesRoute extends PageRouteInfo<ServicesRouteArgs> {
  ServicesRoute({
    Key? key,
    required ClassificationModel classificationModel,
    List<PageRouteInfo>? children,
  }) : super(
         ServicesRoute.name,
         args: ServicesRouteArgs(
           key: key,
           classificationModel: classificationModel,
         ),
         initialChildren: children,
       );

  static const String name = 'ServicesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServicesRouteArgs>();
      return ServicesScreen(
        key: args.key,
        classificationModel: args.classificationModel,
      );
    },
  );
}

class ServicesRouteArgs {
  const ServicesRouteArgs({this.key, required this.classificationModel});

  final Key? key;

  final ClassificationModel classificationModel;

  @override
  String toString() {
    return 'ServicesRouteArgs{key: $key, classificationModel: $classificationModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServicesRouteArgs) return false;
    return key == other.key && classificationModel == other.classificationModel;
  }

  @override
  int get hashCode => key.hashCode ^ classificationModel.hashCode;
}

/// generated route for
/// [Splash]
class SplashTabRoute extends PageRouteInfo<void> {
  const SplashTabRoute({List<PageRouteInfo>? children})
    : super(SplashTabRoute.name, initialChildren: children);

  static const String name = 'SplashTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const Splash();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [SubmittedPriceOffersScreen]
class SubmittedPriceOffersRoute extends PageRouteInfo<void> {
  const SubmittedPriceOffersRoute({List<PageRouteInfo>? children})
    : super(SubmittedPriceOffersRoute.name, initialChildren: children);

  static const String name = 'SubmittedPriceOffersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SubmittedPriceOffersScreen();
    },
  );
}

/// generated route for
/// [SubscriptionScreen]
class SubscriptionRoute extends PageRouteInfo<void> {
  const SubscriptionRoute({List<PageRouteInfo>? children})
    : super(SubscriptionRoute.name, initialChildren: children);

  static const String name = 'SubscriptionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SubscriptionScreen();
    },
  );
}

/// generated route for
/// [UploadFilesScreen]
class UploadFilesRoute extends PageRouteInfo<UploadFilesRouteArgs> {
  UploadFilesRoute({
    Key? key,
    required int contractorId,
    List<PageRouteInfo>? children,
  }) : super(
         UploadFilesRoute.name,
         args: UploadFilesRouteArgs(key: key, contractorId: contractorId),
         initialChildren: children,
       );

  static const String name = 'UploadFilesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UploadFilesRouteArgs>();
      return UploadFilesScreen(key: args.key, contractorId: args.contractorId);
    },
  );
}

class UploadFilesRouteArgs {
  const UploadFilesRouteArgs({this.key, required this.contractorId});

  final Key? key;

  final int contractorId;

  @override
  String toString() {
    return 'UploadFilesRouteArgs{key: $key, contractorId: $contractorId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UploadFilesRouteArgs) return false;
    return key == other.key && contractorId == other.contractorId;
  }

  @override
  int get hashCode => key.hashCode ^ contractorId.hashCode;
}

/// generated route for
/// [UserSignupScreen]
class UserSignupRoute extends PageRouteInfo<void> {
  const UserSignupRoute({List<PageRouteInfo>? children})
    : super(UserSignupRoute.name, initialChildren: children);

  static const String name = 'UserSignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserSignupScreen();
    },
  );
}

/// generated route for
/// [VerificationScreen]
class VerificationRoute extends PageRouteInfo<VerificationRouteArgs> {
  VerificationRoute({
    Key? key,
    required String email,
    bool isUser = false,
    List<PageRouteInfo>? children,
  }) : super(
         VerificationRoute.name,
         args: VerificationRouteArgs(key: key, email: email, isUser: isUser),
         initialChildren: children,
       );

  static const String name = 'VerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteArgs>();
      return VerificationScreen(
        key: args.key,
        email: args.email,
        isUser: args.isUser,
      );
    },
  );
}

class VerificationRouteArgs {
  const VerificationRouteArgs({
    this.key,
    required this.email,
    this.isUser = false,
  });

  final Key? key;

  final String email;

  final bool isUser;

  @override
  String toString() {
    return 'VerificationRouteArgs{key: $key, email: $email, isUser: $isUser}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VerificationRouteArgs) return false;
    return key == other.key && email == other.email && isUser == other.isUser;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode ^ isUser.hashCode;
}
