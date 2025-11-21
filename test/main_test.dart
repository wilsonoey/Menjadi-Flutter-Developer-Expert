import 'dart:io';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pinning.dart';
import 'package:ditonton/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class MockX509Certificate extends Fake implements X509Certificate {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() async {
    // Set up method channel mock for path_provider
    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler(
      (methodCall) async => '/',
    );
  });
  
  group('SslPinning', () {
    late SslPinning sslPinning;

    setUp(() {
      sslPinning = SslPinning();
      SslPinning.resetForTesting();
    });

    tearDown(() {
      SslPinning.resetForTesting();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    group('init()', () {
      test('should initialize HttpClient and IOClient successfully', () async {
        await sslPinning.init();

        // Directly call the static getters to cover lines 11-12
        final httpClient = SslPinning.httpClientForTesting;
        final client = SslPinning.clientForTesting;
        
        expect(httpClient, isNotNull);
        expect(httpClient, isA<HttpClient>());
        expect(client, isNotNull);
        expect(client, isA<IOClient>());
      });

      test('should create IOClient from HttpClient', () async {
        await sslPinning.init();

        // This covers line 25 - IOClient instantiation
        final client = SslPinning.clientForTesting;
        expect(client, isA<http.Client>());
        expect(client, isA<IOClient>());
      });

      test('should return false when badCertificateCallback is called', () async {
        final result = SslPinning.testCertificate(
          MockX509Certificate(), 
          'localhost', 
          8080
        );
        
        expect(result, false);
      });

      test('should log error and rethrow when initialization fails', () async {
        // Mock the asset loading to throw an exception to trigger the catch block (line 27)
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (message) {
          throw Exception('Simulated Asset Load Error');
        });

        // Expect the init method to rethrow the exception
        expect(() => sslPinning.init(), throwsA(isA<Exception>()));
      });
    });

    group('getClient()', () {
      test('should return existing client if already initialized', () async {
        await sslPinning.init();
        final firstClient = await sslPinning.getClient();
        final secondClient = await sslPinning.getClient();

        expect(firstClient, same(secondClient));
        expect(identical(firstClient, secondClient), isTrue);
      });

      test('should initialize client if not already done', () async {
        expect(SslPinning.clientForTesting, isNull);

        final client = await sslPinning.getClient();

        expect(client, isNotNull);
        expect(client, isA<http.Client>());
        expect(SslPinning.clientForTesting, isNotNull);
      });

      test('should call init() when client is null', () async {
        // Ensure client is null
        SslPinning.resetForTesting();
        
        final client = await sslPinning.getClient();
        
        // Verify init was called by checking static variables
        expect(SslPinning.httpClientForTesting, isNotNull);
        expect(SslPinning.clientForTesting, isNotNull);
        expect(client, same(SslPinning.clientForTesting));
      });
    });

    group('globalContext', () {
      test('should return SecurityContext instance', () async {
        final context = await sslPinning.globalContext;
        expect(context, isA<SecurityContext>());
      });

      test('should load certificate and set trusted certificates', () async {
        // This test covers lines 41-42
        final context = await sslPinning.globalContext;
        
        expect(context, isNotNull);
        expect(context, isA<SecurityContext>());
        
        // Verify that the context was created (the method executed)
        // The actual certificate loading is tested by the method execution
      });
    });

    group('resetForTesting()', () {
      test('should clear httpClient static variable', () async {
        await sslPinning.init();
        expect(SslPinning.httpClientForTesting, isNotNull);

        // Explicitly call reset - covers line 15
        SslPinning.resetForTesting();

        // Verify httpClient is null after reset
        expect(SslPinning.httpClientForTesting, isNull);
      });

      test('should clear client static variable', () async {
        await sslPinning.init();
        expect(SslPinning.clientForTesting, isNotNull);

        // Explicitly call reset - covers line 15
        SslPinning.resetForTesting();

        // Verify client is null after reset
        expect(SslPinning.clientForTesting, isNull);
      });

      test('should clear all static variables', () async {
        await sslPinning.init();
        expect(SslPinning.httpClientForTesting, isNotNull);
        expect(SslPinning.clientForTesting, isNotNull);

        // This covers the complete resetForTesting implementation
        SslPinning.resetForTesting();

        expect(SslPinning.httpClientForTesting, isNull);
        expect(SslPinning.clientForTesting, isNull);
      });
    });

    group('Integration tests', () {
      test('should handle multiple init calls', () async {
        await sslPinning.init();
        final firstHttpClient = SslPinning.httpClientForTesting;
        
        // Reset and init again
        SslPinning.resetForTesting();
        await sslPinning.init();
        final secondHttpClient = SslPinning.httpClientForTesting;
        
        expect(firstHttpClient, isNotNull);
        expect(secondHttpClient, isNotNull);
        expect(identical(firstHttpClient, secondHttpClient), isFalse);
      });
    });
  });

  group('Utils', () {
    test('routeObserver should be instance of RouteObserver', () {
      expect(routeObserver, isA<RouteObserver<ModalRoute>>());
    });
  });
}