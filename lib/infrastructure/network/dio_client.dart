import 'package:coc/config/constants/environment.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'https://api.clashofclans.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Authorization': 'Bearer ${Environment.cocKey}',
        'Accept': 'application/json',
      },
    ),
  );
}
