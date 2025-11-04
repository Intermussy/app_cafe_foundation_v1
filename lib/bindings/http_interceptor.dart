import 'dart:io';

import 'package:app_foundation/bindings/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpInterceptor extends http.BaseClient {
  static final Map<String, String> _baseHeader = {
    "Content-type": "application/json",
    "Connection": "keep-alive",
  };

  late http.Client _inner;

  final _appLogger = AppLogger();
  //Singleton setup
  static final HttpInterceptor _instance = HttpInterceptor._internal();
  factory HttpInterceptor() => _instance;
  HttpInterceptor._internal() {
    final ioClient = HttpClient();
    ioClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          _appLogger.warn('ignoring SSL cert for $host');
          return true;
        };

    _inner = IOClient(ioClient);
  }

  String? _token;
  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  //TODO: Add headers by intercepting HTTP Call
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // TODO: implement send
    request.headers.addAll({
      ..._baseHeader,
      if (_token != null) "Authorization": "Bearer $_token",
    });

    _appLogger.log('[HTTP] ${request.method} ${request.url}');

    final response = await _inner.send(request);
    _appLogger.log('[HTTP ${response.statusCode}] ${request.url}');
    return response;
  }
}
