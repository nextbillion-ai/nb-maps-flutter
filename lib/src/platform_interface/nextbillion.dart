part of nb_maps_flutter;

class NextBillion {
  static const MethodChannel _nextBillionChannel = MethodChannel("plugins.flutter.io/nextbillion_init");

  static Future<void> initNextBillion(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod("nextbillion/init_nextbillion", config);
  }

  static Future<String> getAccessKey() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_access_key");
  }

  static Future<void> setAccessKey(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod("nextbillion/set_access_key", config);
  }

  static Future<String> getBaseUri() async {
    return await _nextBillionChannel.invokeMethod("nextbillion/get_base_uri");
  }

  static Future<void> setBaseUri(String baseUri) async {
    Map<String, dynamic> config = {"baseUri": baseUri};
    return await _nextBillionChannel.invokeMethod("nextbillion/set_base_uri", config);
  }
}
