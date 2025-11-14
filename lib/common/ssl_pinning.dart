import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinning {
  static HttpClient? _httpClient;
  static http.Client? _client;

  // Public getters for testing
  static HttpClient? get httpClientForTesting => _httpClient;
  static http.Client? get clientForTesting => _client;

  // Public reset method for testing
  static void resetForTesting() {
    _httpClient = null;
    _client = null;
  }

  Future<void> init() async {
    try {
      _httpClient = HttpClient(context: await globalContext);
      _httpClient!.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      _client = IOClient(_httpClient!);
    } catch (e) {
      print('Error initializing SSL pinning: $e');
      rethrow;
    }
  }

  Future<http.Client> getClient() async {
    if (_client == null) {
      await init();
    }
    return _client!;
  }

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('assets/developer-themoviedb-org.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }
}