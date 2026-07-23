import 'dart:convert';

import 'package:coc/l10n/app_localizations.dart';
import 'package:dio/dio.dart';

enum ApiErrorCode {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  rateLimited,
  server,
  network,
  unexpected,
}

class ApiException implements Exception {
  final ApiErrorCode code;
  final int? statusCode;
  final String? details;

  const ApiException(
    this.code, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() => 'ApiException(${code.name}, status=$statusCode)';
}

ApiException apiExceptionFromStatusCode(int statusCode) {
  return switch (statusCode) {
    400 => const ApiException(ApiErrorCode.badRequest, statusCode: 400),
    401 => const ApiException(ApiErrorCode.unauthorized, statusCode: 401),
    403 => const ApiException(ApiErrorCode.forbidden, statusCode: 403),
    404 => const ApiException(ApiErrorCode.notFound, statusCode: 404),
    429 => const ApiException(ApiErrorCode.rateLimited, statusCode: 429),
    >= 500 && <= 599 =>
      ApiException(ApiErrorCode.server, statusCode: statusCode),
    _ => ApiException(ApiErrorCode.unexpected, statusCode: statusCode),
  };
}

Map<String, dynamic>? _asJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) {
    return data.map((key, value) => MapEntry(key.toString(), value));
  }
  if (data is String && data.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      return _asJsonMap(decoded);
    } catch (_) {
      return null;
    }
  }
  return null;
}

bool _looksLikeNotFound({
  required int? statusCode,
  required String? reason,
  required String? message,
}) {
  if (statusCode == 404) return true;
  final reasonNorm = reason?.toLowerCase().replaceAll(RegExp(r'[\s_]'), '');
  if (reasonNorm == 'notfound') return true;
  final messageNorm = message?.toLowerCase() ?? '';
  return messageNorm.contains('not found') ||
      messageNorm.contains('notfound') ||
      messageNorm.contains('no encontrado') ||
      messageNorm.contains('no existe');
}

ApiException apiExceptionFromDio(DioException error) {
  final map = _asJsonMap(error.response?.data);
  final reason = map?['reason']?.toString();
  final message = map?['message']?.toString();
  final statusCode = error.response?.statusCode;

  if (_looksLikeNotFound(
    statusCode: statusCode,
    reason: reason,
    message: message,
  )) {
    return ApiException(
      ApiErrorCode.notFound,
      statusCode: statusCode ?? 404,
      details: message ?? reason,
    );
  }

  if (statusCode != null) {
    return apiExceptionFromStatusCode(statusCode);
  }

  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionError) {
    return const ApiException(ApiErrorCode.network);
  }

  return ApiException(
    ApiErrorCode.unexpected,
    details: message ?? error.message,
  );
}

ApiException apiExceptionFromObject(Object error) {
  if (error is ApiException) return error;
  if (error is DioException) return apiExceptionFromDio(error);
  return ApiException(
    _resolveCode(error),
    details: error.toString(),
  );
}

/// Prefer typed [ApiException]; also recognizes legacy English strings.
String localizedApiError(Object error, AppLocalizations l10n) {
  final code = _resolveCode(error);
  return switch (code) {
    ApiErrorCode.badRequest => l10n.apiErrorBadRequest,
    ApiErrorCode.unauthorized => l10n.apiErrorUnauthorized,
    ApiErrorCode.forbidden => l10n.apiErrorForbidden,
    ApiErrorCode.notFound => l10n.apiErrorPlayerNotFound,
    ApiErrorCode.rateLimited => l10n.apiErrorRateLimited,
    ApiErrorCode.server => l10n.apiErrorServer,
    ApiErrorCode.network => l10n.apiErrorNetwork,
    ApiErrorCode.unexpected => l10n.apiErrorUnexpected,
  };
}

bool isApiForbidden(Object error) =>
    _resolveCode(error) == ApiErrorCode.forbidden;

bool isApiNotFound(Object error) =>
    _resolveCode(error) == ApiErrorCode.notFound;

ApiErrorCode _resolveCode(Object error) {
  if (error is ApiException) return error.code;
  if (error is DioException) return apiExceptionFromDio(error).code;

  final text = error.toString().toLowerCase().replaceAll(RegExp(r'[\s_]'), '');
  if (text.contains('notfound') ||
      text.contains('noexiste') ||
      text.contains('noencontr')) {
    return ApiErrorCode.notFound;
  }
  if (text.contains('403') || text.contains('forbidden') || text.contains('denegado')) {
    return ApiErrorCode.forbidden;
  }
  if (text.contains('401') || text.contains('unauthorized')) {
    return ApiErrorCode.unauthorized;
  }
  if (text.contains('400') || text.contains('badrequest')) {
    return ApiErrorCode.badRequest;
  }
  if (text.contains('429') || text.contains('ratelimit')) {
    return ApiErrorCode.rateLimited;
  }
  if (text.contains('500') ||
      text.contains('502') ||
      text.contains('503') ||
      text.contains('internalserver')) {
    return ApiErrorCode.server;
  }
  if (text.contains('connection') ||
      text.contains('internet') ||
      text.contains('conex')) {
    return ApiErrorCode.network;
  }
  return ApiErrorCode.unexpected;
}

/// Kept for call sites that still pass a bare status code.
Exception handleDioException(int statusCode) =>
    apiExceptionFromStatusCode(statusCode);
