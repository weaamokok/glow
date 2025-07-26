import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:glow/l10n/translations.g.dart';

class AppExceptionHandler {
  static final _t = LocaleSettings.instance.currentTranslations.core;

  static String getMessage(Object error, {StackTrace? stackTrace}) {
    if (error is DioException) {
      return _handleDio(error);
    } else if (error is SocketException) {
      return _t.noInternetConnection;
    } else if (error is FormatException) {
      return _t.formatException;
    } else if (error is JsonUnsupportedObjectError) {
      return _t.invalidJsonStructure;
    } else if (error is HandshakeException) {
      return _t.sslHandshakeFailed;
    } else if (error is TimeoutException) {
      return _t.connectionTimeout;
    } else if (error is TypeError) {
      return _t.typeMismatch;
    } else {
      debugPrint('Unhandled error: $error\n$stackTrace');
      return _t.unexpectedError;
    }
  }

  static String _handleDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return _t.requestCancelled;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return _t.connectionTimeout;
      case DioExceptionType.connectionError:
        return _t.connectionError;
      case DioExceptionType.badCertificate:
        return _t.badCertificate;
      case DioExceptionType.unknown:
        return _handleDioUnknown(error);
      case DioExceptionType.badResponse:
        return _handleHttpError(error.response);
    }
  }

  static String _handleDioUnknown(DioException error) {
    final msg = error.message ?? '';
    if (msg.contains('Connection refused')) return _t.serverMaintenance;
    if (msg.contains('Network is unreachable')) return _t.networkUnreachable;
    if (msg.contains('Failed host lookup')) return _t.noInternetConnection;
    return _t.unknownError;
  }

  static String _handleHttpError(Response? response) {
    final code = response?.statusCode ?? 0;
    final data = response?.data;

    switch (code) {
      case 400:
        return _extractMessage(data) ?? _t.badRequest;
      case 401:
      case 403:
        return _t.unauthorizedRequest;
      case 404:
        return _t.notFound;
      case 408:
        return _t.requestTimeout;
      case 500:
        return _t.internalServerError;
      case 503:
        return _t.serviceUnavailable;
      default:
        return _t.unexpectedError;
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final first = data.values.first;
      if (first is String) return first;
      if (first is Map && first.values.first is List) {
        return first.values.first.first.toString();
      }
    }
    return null;
  }
}
