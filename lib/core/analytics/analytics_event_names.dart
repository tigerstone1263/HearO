/// Analytics event names as constants
/// This class contains all analytics event names used throughout the app
/// to ensure consistency and prevent typos
class AnalyticsEventNames {

  //utm
  static const String utmLinkClicked = 'utm_link_clicked';

  // App Lifecycle Events
  static const String appOpen = 'app_open';
  static const String appTerminate = 'app_terminate';
  static const String appForeground = 'app_foreground';
  static const String appBackground = 'app_is_background';
  
  // Navigation Events
  static const String navigateToScreen = 'navigate_to_screen';
  static const String homeTabNavigation = 'home_tap_navigation_tab';
  static const String screenView = 'screen_view';
  
  // Authentication Events
  static const String authTapGoogleLogin = 'auth_tap_google_login';
  static const String authTapAppleLogin = 'auth_tap_apple_login';
  static const String authTapKakaoLogin = 'auth_tap_kakao_login';
  static const String authTapGuestLogin = 'auth_tap_guest_login';
  static const String authenticationError = 'authentication_error';

  //Share Events
  static const String shareApp = 'share_app';
  static const String shareIssue = 'share_issue';

  // Issue Events
  static const String issueTapItem = 'issue_tap_item';
  static const String issueViewItem = 'issue_view_item';
  static const String issueSwipeItem = 'issue_swipe_item';
  static const String issueShareItem = 'issue_share_item';
  static const String openHotIssues = 'open_hot_issues';

  // Article Events
  static const String fecthWebArticle = 'fetch_web_article';
  
  // Media Events
  static const String mediaTapItem = 'media_tap_item';
  static const String mediaViewItem = 'media_view_item';
  static const String mediaFollowItem = 'media_follow_item';
  static const String mediaUnfollowItem = 'media_unfollow_item';
  
  // Topic Events
  static const String topicTapItem = 'topic_tap_item';
  static const String topicViewItem = 'topic_view_item';
  static const String topicFollowItem = 'topic_follow_item';
  static const String topicUnfollowItem = 'topic_unfollow_item';
  
  // Button/Action Events - Dynamic event names
  static String buttonTap(String module, String buttonName) => 
      '${module}_tap_${buttonName}_button';
  
  // Form Events - Dynamic event names
  static String formSubmit(String formName) => 
      'form_submit_$formName';
  
  // Swipe Events - Dynamic event names
  static String swipe(String module, String itemType) => 
      '${module}_swipe_$itemType';
  
  // Dialog Events - Dynamic event names
  static String dialog(String action, String dialogName) => 
      'dialog_${action}_$dialogName';
  
  // Search Events
  static const String search = 'search';
  static const String tapSearchBar = 'tap_search_bar';
  static const String clearSearch = 'clear_search';
  
  // Refresh Events
  static const String pullToRefresh = 'pull_to_refresh';
  
  // Update Events
  static const String checkForUpdate = 'check_for_update';
  static const String startUpdate = 'start_update';
  
  // Error Events
  static const String networkError = 'network_error';
  
  // Permission Events
  static const String requestPermission = 'request_permission';
  
  // Deep Link Events
  static const String openDeepLink = 'open_deep_link';
  
  // Scroll Events
  
  // Long Press Events
  static const String longPress = 'long_press';
  
  // Share Events (additional)
  static const String share = 'share';
  
  // Subscription Events
  static const String subscribe = 'subscribe';
  static const String unsubscribe = 'unsubscribe';
  
  // Filter Events
  static const String filterApplied = 'filter_applied';
  
  // Tab Navigation Events
  static const String tabNavigation = 'tab_navigation';
  static const String tabReselection = 'tab_reselection';
  
  // Use Case Events
  // Fetch Events
  static const String fetchArticles = 'fetch_articles';
  static const String fetchHotIssues = 'fetch_hot_issues';
  static const String fetchIssueQueryParams = 'fetch_issue_query_params';
  static const String fetchDailyIssues = 'fetch_daily_issues';

  static const String fetchIssuesWithWholeCategories = 'fetch_issues_with_whole_categories';
  static const String fetchIssuesWithCategory = 'fetch_issues_with_category';

  // static const String fetchBlindSpotLeftIssues = 'fetch_blind_spot_left_issues';
  // static const String fetchBlindSpotRightIssues = 'fetch_blind_spot_right_issues';
  static const String fetchForYouIssues = 'fetch_for_you_issues';
  static const String fetchWatchHistoryIssues = 'fetch_watch_history_issues';
  static const String fetchSubscribedIssues = 'fetch_subscribed_issues';
  static const String fetchSubscribedTopicIssues = 'fetch_subscribed_topic_issues';
  static const String fetchEvaluatedIssues = 'fetch_evaluated_issues';
  static const String fetchIssuesByTopicId = 'fetch_issues_by_topic_id';
  static const String fetchIssueDetail = 'fetch_issue_detail';
  static const String fetchMediaList = 'fetch_media_list';
  static const String fetchSubscribedMedia = 'fetch_subscribed_media';
  static const String fetchMediaDetail = 'fetch_media_detail';
  static const String fetchNotices = 'fetch_notices';
  static const String fetchSourceDetail = 'fetch_source_detail';

  static const String fetchAllSources = 'fetch_all_sources';
  static const String fetchSubscribedSources = 'fetch_subscribed_sources';
  static const String fetchTopicDetail = 'fetch_topic_detail';
  static const String fetchTopics = 'fetch_topics';
  static const String fetchUserBias = 'fetch_user_bias';
  static const String fetchWholeBiasScore = 'fetch_whole_bias_score';
  static const String updateWholeBiasScore = 'update_whole_bias_score';
  
  // Search Events
  static const String searchIssues = 'search_issues';
  static const String searchTopics = 'search_topics';
  
  // Manage Events
  static const String manageIssueEvaluation = 'manage_issue_evaluation';
  static const String manageIssueSubscription = 'manage_issue_subscription';
  static const String manageMediaSubscription = 'manage_media_subscription';
  static const String manageSourceEvaluation = 'manage_source_evaluation';
  static const String manageTopicSubscription = 'manage_topic_subscription';
  static const String manageUserProfile = 'manage_user_profile';
  static const String uploadProfileImage = 'upload_profile_image';
  static const String deleteUserProfileImage = 'delete_user_profile_image';
  static const String manageUserStatus = 'manage_user_status';
  
  // Submit Events
  static const String submitFeedback = 'submit_feedback';
  
  // Track Events
  static const String trackUserActivity = 'track_user_activity';
  static const String postDasiScore = 'post_dasi_score';
  
  // Additional Fetch Events
  static const String fetchDasiScore = 'fetch_dasi_score';
  static const String fetchBiasScoreHistory = 'fetch_bias_score_history';
  static const String fetchEvaluatedSources = 'fetch_evaluated_sources';
  static const String fetchArticlesBySourceId = 'fetch_articles_by_source_id';
  static const String fetchArticlesByIssueId = 'fetch_articles_by_issue_id';
  static const String fetchArticlesSubscribed = 'fetch_articles_subscribed';

  static const String fetchArticleInDetail = 'fetch_article_in_detail';
  
  // User Management Events
  static const String checkUserRegisterStatus = 'check_user_register_status';
  static const String registerIdToken = 'register_id_token';
  static const String deleteUserAccount = 'delete_user_account';
  static const String updateUserNickname = 'update_user_nickname';
  
  // Firebase Login Events
  static const String signInWithKakao = 'sign_in_with_kakao';
  static const String signInAnonymous = 'sign_in_anonymous';
  static const String signInWithApple = 'sign_in_with_apple';
  static const String signInWithGoogle = 'sign_in_with_google';
  static const String signOut = 'sign_out';
  
  // Dynamic event name builders for specific patterns
  static String authLogin(String method) => 
      'auth_tap_${method}_login';
  
  static String issueAction(String action) => 
      'issue_${action}_item';
  
  static String mediaAction(String action) => 
      'media_${action}_item';
  
  static String topicAction(String action) => 
      'topic_${action}_item';
}