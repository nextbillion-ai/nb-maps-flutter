part of nb_maps_flutter;

class NextBillion {
  static MethodChannel _nextBillionChannel =
      MethodChannel("plugins.flutter.io/nextbillion_init");

  get channel => _nextBillionChannel;

  @visibleForTesting
  static setMockMethodChannel(MethodChannel channel) {
    _nextBillionChannel = channel;
  }

  /// Initializes the NextBillion SDK with the provided [accessKey].
  static Future<void> initNextBillion(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/init_nextbillion", config);
  }

  /// Retrieves the access key.
  /// To get the current access key used for initNextBillion.
  /// Returns a [Future] that completes with the access key as a [String].
  static Future<String> getAccessKey() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_access_key");
  }

  /// Sets the access key.
  /// [accessKey] The access key to be set.
  static Future<void> setAccessKey(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_access_key", config);
  }

  /// Retrieves the base URI.
  /// To get the current base URI used for Map Style API requests.
  ///
  /// Returns a [Future] that completes with the base URI as a [String].
  static Future<String> getBaseUri() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_base_uri");
  }

  /// Sets the base URI.
  ///
  /// To set a new base URI used for Map Style API requests.
  ///
  /// [baseUri] The base URI to be set.
  static Future<void> setBaseUri(String baseUri) async {
    Map<String, dynamic> config = {"baseUri": baseUri};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_base_uri", config);
  }

  /// Sets the API key header name.
  ///
  /// To set a new header name used for the API key in HTTP requests.
  ///
  /// [apiKeyHeaderName] The name of the API key header to be set.
  ///
  static Future<void> setApiKeyHeaderName(String apiKeyHeaderName) async {
    Map<String, dynamic> config = {"apiKeyHeaderName": apiKeyHeaderName};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_key_header_name", config);
  }

  /// Retrieves the API key header name.
  ///
  /// To get the current header name used for the API key in HTTP requests.
  static Future<String> getApiKeyHeaderName() async {
    return await _nextBillionChannel
        .invokeMethod("nextbillion/get_key_header_name");
  }

  /// Get the NextBillion ID for the current user.
  static Future<String> getNbId() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_nb_id");
  }

  /// Set the user ID for the current user if you need to add a user ID to the navigation request user-agent.
  static Future<void> setUserId(String id) async {
    Map<String, dynamic> config = {"userId": id};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_user_id", config);
  }

  /// Get the user ID for the current user if you need to add a user ID to the navigation request user-agent.
  static Future<String?> getUserId() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_user_id");
  }
}
