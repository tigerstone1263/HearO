/// Analytics parameter keys as constants
/// This class contains all analytics parameter keys used throughout the app
/// to ensure consistency and prevent typos
class AnalyticsParameterKeys {

  //utm
  static const String utm = 'utm';

  static const String category = 'category';

  // Navigation Parameters
  static const String fromScreen = 'from_screen';
  static const String toScreen = 'to_screen';
  static const String screenName = 'screen_name';
  static const String screenClass = 'screen_class';
  static const String tabName = 'tab_name';
  
  // Authentication Parameters
  static const String method = 'method';
  static const String success = 'success';
  static const String granted = 'granted';
  
  // Content Parameters
  static const String contentType = 'content_type';
  static const String contentId = 'content_id';
  static const String contentName = 'content_name';
  static const String itemType = 'item_type';
  static const String itemId = 'item_id';
  static const String itemName = 'item_name';
  
  // Issue Parameters
  static const String issueId = 'issue_id';
  static const String issueTitle = 'issue_title';
  static const String issueCategory = 'issue_category';
  static const String issueTags = 'issue_tags';
  static const String bias = 'bias';
  static const String perspective = 'perspective';
  
  // Media Parameters
  static const String mediaId = 'media_id';
  static const String mediaName = 'media_name';
  static const String sourceId = 'source_id';
  static const String sourceName = 'source_name';
  
  // Topic Parameters
  static const String topicId = 'topic_id';
  static const String topicName = 'topic_name';
  
  // Article Parameters
  static const String articleId = 'article_id';
  static const String articleTitle = 'article_title';
  static const String selectedArticleId = 'selected_article_id';
  static const String selectedSourceId = 'selected_source_id';
  
  // Action Parameters
  static const String action = 'action';
  static const String module = 'module';
  static const String buttonName = 'button_name';
  static const String formName = 'form_name';
  static const String dialogName = 'dialog_name';
  
  // Scroll Parameters
  static const String direction = 'direction';
  static const String scrollPosition = 'scroll_position';
  
  // Search Parameters
  static const String searchTerm = 'search_term';
  static const String searchType = 'search_type';
  static const String query = 'query';
  
  // Search Type Values (실제 사용되는 것만)
  static const String searchTypeIssue = 'issue_search';
  static const String searchTypeTopic = 'topic_search';
  
  // Filter Parameters
  static const String filterType = 'filter_type';
  static const String filterValue = 'filter_value';
  
  // Error Parameters
  static const String errorType = 'error_type';
  static const String errorMessage = 'error_message';
  static const String errorCode = 'error_code';
  
  // State Parameters
  static const String state = 'state';
  static const String spread = 'spread';
  static const String fontSize = 'font_size';
  
  // Source Parameters
  static const String source = 'source';
  static const String deepLink = 'deep_link';
  
  // Additional Parameters
  static const String parameters = 'parameters';
  static const String additionalParams = 'additional_params';
  static const String value = 'value';
  static const String name = 'name';
}