import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalyticsService _instance =
      FirebaseAnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  factory FirebaseAnalyticsService() {
    return _instance;
  }

  FirebaseAnalyticsService._internal();

  // Track screen view
  Future<void> logScreenView({required String screenName}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenName,
      );
      print('✓ Screen view logged: $screenName');
    } catch (e) {
      print('✗ Error logging screen view: $e');
    }
  }
  
  // Track movie detail view
  Future<void> logMovieDetailView({required int movieId}) async {
    try {
      await _analytics.logEvent(
        name: 'view_item',
        parameters: {
          'item_id': movieId.toString(),
          'item_name': 'Movie Detail',
          'content_type': 'movie',
        },
      );
      print('✓ Movie detail view logged: $movieId');
    } catch (e) {
      print('✗ Error logging movie detail: $e');
    }
  }

  // Track TV series detail view
  Future<void> logTVSeriesDetailView({required int tvSeriesId}) async {
    try {
      await _analytics.logEvent(
        name: 'view_item',
        parameters: {
          'item_id': tvSeriesId.toString(),
          'item_name': 'TV Series Detail',
          'content_type': 'tv_series',
        },
      );
      print('✓ TV series detail view logged: $tvSeriesId');
    } catch (e) {
      print('✗ Error logging TV series detail: $e');
    }
  }
}