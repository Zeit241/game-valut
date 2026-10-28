import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
class ApiClient {
  static late final Dio dio;
  static late final CacheOptions cacheOptions;

  ApiClient() {
    cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.forceCache,
      maxStale: const Duration(days: 1),
      hitCacheOnNetworkFailure: true,
    );

    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.rawg.io/api',
        connectTimeout: const Duration(seconds: 1000),
        receiveTimeout: const Duration(seconds: 1000),
        headers: {'Accept': 'application/json'},
        queryParameters: {'key': dotenv.env['API_KEY'] ?? ''},
      ),
    );

    // dio.interceptors.add(
    //     PrettyDioLogger(
    //       // requestHeader: true,
    //       // requestBody: true,
    //       // responseHeader: false,
    //       // responseBody: true,
    //       error: true,
    //       compact: true,
    //       maxWidth: 90,
    //     ));

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }
}

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  final int? count;
  const Success({required this.data, this.count});
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}