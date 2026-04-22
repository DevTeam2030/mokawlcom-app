class ApiConstants {
  ////base url
  static const String baseUrl = "https://mokawlcom.com/m/public/api";
  static const String appVerionEndpoint = "/app-version";
  
  // user auth
  static const String userSignup = "/auth/register-user";
  static const String activateAccount = "/auth/activate-acount";
  static const String userLogin = "/auth/login";
  static const String userLoginGoogle = "/auth/login-google";
  static const String userLoginApple = "/auth/login-apple";
  // contractor auth
  static const String getClassifications = "/categories";
  static const String getServices = "/sub-categories";
  static const String getBanners = "/banners";
  static const String contractorSignup = "/auth/register-contractor";
  static const String uploadCommercialRegistry = "/auth/upload-commercial-registry";
  static const String uploadTradeLicense = "/auth/upload-trade-license";
  static const String uploadEstablishmentCertificate = "/auth/upload-establishment-certificate";
  static const String uploadAuthorizedSignature = "/auth/upload-authorized-signature";
  static const String completeContractorData = "/complete-contractor-data";
  static const String subscibePlan = "/subscribe-plan";
  static const String forgetPassword = "/auth/password-reset-email";
  static const String getContractors = "/get-contractors";
  static const String getContractorInfo = "/get-contractor-info";
  static const String rateContractor = "/rate";
  static const String addOfferPrice = "/add-offer-price";
  static const String getFavorites = "/favorite-list";
  static const String addFavorite = "/favorite";
  static const String removeFavorite = "/un-favorite";
  static const String getPublicNotifications = "/public-notifications";
  static const String getOfferNotifications = "/offer-notifications";
  static const String updateProfile = "/update-profile";
  static const String changeImage = "/change-image-profile";
  static const String getOfferDetails = "/show-offer";
  static const String replayOfferPrice = "/replay-offer-price";
  static const String changePassword = "/change-password";
  static const String deleteAccount = "/delete-account";
  static const String editContractorProfile = "/update-profile-owner";
  static const String logout = "/auth/logout";
  static const String profile = "/user-profile";
  static const String userOffers = "/user-offers";
  static const String getContractorServices = "/get-services";
  static const String addService = "/add-service";
  static const String editService = "/edit-service";
  static const String getDeals = "/user-deals";
  static const String addDeal = "/add-deal";
  static const String deleteDeal = "/delete-deal";
  static const String editDeal = "/update-deal";
  static const String getPlan = "/my-plan";
  static const String deleteService = "/delete-service";
  static const String getSettings = "/settings";
}
