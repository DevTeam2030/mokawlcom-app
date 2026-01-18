import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../locale_keys.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  final bool isConnected;
  const Failure(this.errorMessage, {this.isConnected = true});

  @override
  List<Object> get props => [errorMessage, isConnected];
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage, {super.isConnected = true});

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionError:
        return ServerFailure(
          // 'Connection to API server failed due to internet connection',
          LocaleKeys.noInternetConnection,
          isConnected: false,
        );
      case DioExceptionType.cancel:
        return ServerFailure(LocaleKeys.requestCancelled, isConnected: false);
      case DioExceptionType.connectionTimeout:
        return ServerFailure(LocaleKeys.connectionTimeout, isConnected: false);
      case DioExceptionType.sendTimeout:
        return ServerFailure(LocaleKeys.sendTimeout, isConnected: false);

      case DioExceptionType.receiveTimeout:
        return ServerFailure(LocaleKeys.receiveTimeout, isConnected: false);
      case DioExceptionType.badResponse:
        return ServerFailure.fromBadResponse(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return ServerFailure(
            LocaleKeys.noInternetConnection,
            isConnected: false,
          );
        }
        return ServerFailure(LocaleKeys.unexpectedError, isConnected: false);
      default:
        return ServerFailure(
          dioError.message ?? LocaleKeys.generalError,
          isConnected: false,
        );
    }
  }

  factory ServerFailure.fromBadResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response["message"]);
    } else if (statusCode == 404) {
      return ServerFailure(LocaleKeys.requestNotFound);
    } else if (statusCode == 500) {
      return ServerFailure(LocaleKeys.internalServerError);
    }
    return ServerFailure(response["message"]);
  }
}
