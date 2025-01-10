part of nb_maps_flutter;

Map<String, dynamic> buildFeatureCollection(List<Map<String, dynamic>> features) {
  return {"type": "FeatureCollection", "features": features};
}

final _random = Random();
String getRandomString([int length = 10]) {
  const charSet = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(Iterable.generate(length, (_) => charSet.codeUnitAt(_random.nextInt(charSet.length))));
}

/// Logs a debug message.
///
/// This method prints the [message] to the console only if the app is in
/// debug mode. In release mode, it does nothing.
///
/// [message] The message to log.
void debugLog(String message) {
  if (!kReleaseMode) {
    print('$message');
  }
}
