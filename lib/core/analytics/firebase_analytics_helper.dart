import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hear_o/core/di/di_setup.dart';

import 'analytics_event_names.dart';

class FirebaseAnalyticsHelper {
  static final FirebaseAnalytics _analytics = getIt<FirebaseAnalytics>();

  // Navigation Events
  static Future<void> logNavigationEvent({
    required String fromScreen,
    required String toScreen,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.navigateToScreen,
      parameters: {
        'from_screen': fromScreen,
        'to_screen': toScreen,
        ...?parameters,
      },
    );
  }

  // Tab Navigation Events
  static Future<void> logTabNavigation({
    required int tabIndex,
    required String tabName,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.homeTabNavigation,
      parameters: {
        'tab_index': tabIndex,
        'tab_name': tabName,
      },
    );
  }

  // Authentication Events
  static Future<void> logAuthEvent({
    required String method,
    required String success,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.authLogin(method),
      parameters: {
        'method': method,
        'success': success,
      },
    );
  }

  // Issue Events
  static Future<void> logIssueEvent({
    required String action,
    required String issueId,
    Map<String, dynamic>? additionalParams,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.issueAction(action),
      parameters: {
        'issue_id': issueId,
        ...?additionalParams,
      },
    );
  }

  // Media Events
  static Future<void> logMediaEvent({
    required String action,
    required String mediaId,
    String? mediaName,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.mediaAction(action),
      parameters: {
        'media_id': mediaId,
        if (mediaName != null) 'media_name': mediaName,
      },
    );
  }

  // Topic Events
  static Future<void> logTopicEvent({
    required String action,
    required String topicId,
    String? topicName,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.topicAction(action),
      parameters: {
        'topic_id': topicId,
        if (topicName != null) 'topic_name': topicName,
      },
    );
  }

  // Button/Action Events
  static Future<void> logButtonTap({
    required String module,
    required String buttonName,
    Map<String, String>? parameters,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.buttonTap(module, buttonName),
      parameters: parameters,
    );
  }

  // Form Events
  static Future<void> logFormSubmit({
    required String formName,
    required String success,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.formSubmit(formName),
      parameters: {
        'success': success,
        ...?parameters,
      },
    );
  }

  // Swipe Events
  static Future<void> logSwipeEvent({
    required String module,
    required String itemType,
    required int index,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.swipe(module, itemType),
      parameters: {
        'index': index,
      },
    );
  }

  // Pull to Refresh Events
  static Future<void> logRefreshEvent({
    required String screenName,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.pullToRefresh,
      parameters: {
        'screen': screenName,
      },
    );
  }

  // Dialog Events
  static Future<void> logDialogEvent({
    required String action,
    required String dialogName,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.dialog(action, dialogName),
    );
  }

  // Search Events
  static Future<void> logSearchEvent({
    required String searchTerm,
    String? searchType,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.search,
      parameters: {
        'search_term': searchTerm,
        if (searchType != null) 'search_type': searchType,
      },
    );
  }

  // Generic Event Logger
  static Future<void> logEvent({
    required String name,
    Map<String, String>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Screen View Events
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // User Properties
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Set User ID
  static Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }
}