import 'package:coc/config/constants/environment.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: Environment.apiBaseUrl,
      // Cloud Run + NAT cold starts can exceed 30s on the first request.
      connectTimeout: Environment.usesRemoteProxy
          ? const Duration(seconds: 60)
          : const Duration(seconds: 15),
      receiveTimeout: Environment.usesRemoteProxy
          ? const Duration(seconds: 60)
          : const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        // Direct Supercell calls (dev only). Production must use the proxy
        // so the key never ships inside the app.
        if (!Environment.usesProxy && Environment.cocKey.isNotEmpty)
          'Authorization': 'Bearer ${Environment.cocKey}',
      },
    ),
  );
}
