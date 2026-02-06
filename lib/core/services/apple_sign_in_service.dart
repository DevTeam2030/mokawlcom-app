import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_apple_login_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInService {
  static final AppleSignInService _instance = AppleSignInService._internal();
  factory AppleSignInService() => _instance;
  AppleSignInService._internal();

  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserAppleLoginModel> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      return UserAppleLoginModel(
        idToken: appleCredential.identityToken ?? "",
        name: appleCredential.givenName ?? "",
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled ||
          e.code == AuthorizationErrorCode.unknown) {
        debugPrint("User cancelled Apple Sign-In");
        throw const ServerException(errorMessage: "");
      }
      throw ServerException(errorMessage: e.toString());
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
