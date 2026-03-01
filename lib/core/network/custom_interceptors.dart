import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class CustomInterceptors extends Interceptor {
  static bool _isRedirectingToAuth = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('REQUEST[${options.method}] => PATH: ${options.path}');
    options.queryParameters['lang'] = AppConstants.language;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    final statusCode = err.response?.statusCode;
    String message = '';
    final responseData = err.response?.data;
    if (responseData is Map && responseData['message'] != null) {
      message = responseData['message'].toString().toLowerCase();
    } else if (responseData != null) {
      message = responseData.toString().toLowerCase();
    }
    message = message.isEmpty ? (err.message?.toLowerCase() ?? '') : message;

    if (statusCode == 401 &&
        message.contains('please login') &&
        !_isRedirectingToAuth) {
      _isRedirectingToAuth = true;

      try {
        final cacheHelper = getIt<CacheHelper>();
        cacheHelper.deleteAll();
        AppConstants.token = '';
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final context = AppRouter.rootNavigatorKey.currentContext;
          if (context != null && context.mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => ErrorDialog(
                theme: Theme.of(context),
                message: LocaleKeys.pleaseLoginAgain,
                buttonText: LocaleKeys.continueKey,
              ),
            );
            if (context.mounted) {
              context.replaceRoute(const AuthRoute());
            }
          }
          _isRedirectingToAuth = false;
        });
      } catch (_) {
        _isRedirectingToAuth = false;
      }
    }

    super.onError(err, handler);
  }
}
