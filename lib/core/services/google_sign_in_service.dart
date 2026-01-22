import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class GoogleSignInService {
  GoogleSignInService._();
  static final GoogleSignInService instance = GoogleSignInService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;
  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;

    unawaited(
      _googleSignIn
          .initialize(serverClientId: AppConstants.serverClientId)
          .then((_) {
            _authSub = _googleSignIn.authenticationEvents.listen(
              _handleAuthEvent,
              onError: _handleAuthError,
            );
          }),
    );

    _isInitialized = true;
  }

  Future<String?> signIn() async {
    try {
      await _init();

      // Create a new completer for this sign-in attempt
      final completer = Completer<String?>();
      _currentCompleter = completer;

      if (_googleSignIn.supportsAuthenticate()) {
        await _googleSignIn.authenticate();
        return await completer.future;
      } else {
        throw ServerException(
          errorMessage: LocaleKeys.googleSignInNotSupportedOnThisPlatform,
        );
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint("User cancelled Google Sign-In");
        throw const ServerException(
          errorMessage: "",
        );
      }
      throw ServerException(errorMessage: e.toString());
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  Completer<String?>? _currentCompleter;

  Future<void> _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final user = event.user;
      final auth = user.authentication;
      final idToken = auth.idToken;

      debugPrint("User email: ${user.email}");
      debugPrint("ID Token: $idToken");

      // Complete the sign-in with the idToken
      if (_currentCompleter != null && !_currentCompleter!.isCompleted) {
        _currentCompleter!.complete(idToken);
      }
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      debugPrint("User signed out");
    }
  }

  void _handleAuthError(Object error) {
    debugPrint("Google Sign-In error: $error");
    if (_currentCompleter != null && !_currentCompleter!.isCompleted) {
      _currentCompleter!.completeError(error);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  void dispose() {
    _authSub?.cancel();
  }
}
