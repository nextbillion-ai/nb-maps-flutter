part of nb_maps_flutter;

class NextBillion {
  static const MethodChannel _nextBillionChannel = MethodChannel("plugins.flutter.io/nextbillion_init");

  static Future<void> initNextBillion(String accessKey) async {
    Map<String, dynamic> config = {"accessKey": accessKey};
    return await _nextBillionChannel.invokeMethod("nextbillion/init_nextbillion", config);
  }

}