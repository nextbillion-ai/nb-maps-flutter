part of nb_maps_flutter;

class NextBillion {
  static MethodChannel _nextBillionChannel =
      MethodChannel("plugins.flutter.io/nextbillion_init");

  get channel => _nextBillionChannel;

  @visibleForTesting
  static setMockMethodChannel(MethodChannel channel) {
    _nextBillionChannel = channel;
  }

  static Future<void> initNextBillion(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/init_nextbillion", config);
  }

  static Future<String> getAccessKey() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_access_key");
  }

  static Future<void> setAccessKey(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_access_key", config);
  }

  static Future<String> getBaseUri() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_base_uri");
  }

  static Future<void> setBaseUri(String baseUri) async {
    Map<String, dynamic> config = {"baseUri": baseUri};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_base_uri", config);
  }

  static Future<void> setApiKeyHeaderName(String apiKeyHeaderName) async {
    Map<String, dynamic> config = {"apiKeyHeaderName": apiKeyHeaderName};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_key_header_name", config);
  }

  static Future<String> getApiKeyHeaderName() async {
    return await _nextBillionChannel
        .invokeMethod("nextbillion/get_key_header_name");
  }

  static Future<String> getNbId() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_nb_id");
  }

  static Future<void> setUserId(String id) async {
    Map<String, dynamic> config = {"userId": id};
    return await _nextBillionChannel.invokeMethod(
        "nextbillion/set_user_id", config);
  }

  static Future<String?> getUserId() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_user_id");
  }
}
