import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';

class GoogleSignInService {
  GoogleSignInService._(); 
  static final GoogleSignInService instance = GoogleSignInService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;
  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;

    unawaited(
      _googleSignIn.initialize(
        serverClientId: AppConstans.serverClientId,
      ).then((_) {
        _authSub = _googleSignIn.authenticationEvents
            .listen(_handleAuthEvent,onError: _handleAuthError);

       // _googleSignIn.attemptLightweightAuthentication();
      }),
    );

    _isInitialized = true;
  }

 Future<void> signIn() async {
  try {
    await _init();
    if (_googleSignIn.supportsAuthenticate()) {
      await _googleSignIn.authenticate();
    } else {
      throw const ServerException(
        errorMessage: "Google Sign-In not supported on this platform",
      );
    }
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      debugPrint("User cancelled Google Sign-In");
      return; 
    }
    throw ServerException(errorMessage: e.toString());
  } catch (e) {
    throw ServerException(errorMessage: e.toString());
  }
}


   Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final user = event.user;
      final auth =  user.authentication; 
      final idToken = auth.idToken;

      debugPrint("User email: ${user.email}");
      debugPrint("ID Token: $idToken");

    }
  }

  void _handleAuthError(Object error) {
    debugPrint("Google Sign-In error: $error");
  }

  void dispose() {
    _authSub?.cancel();
  }
}
