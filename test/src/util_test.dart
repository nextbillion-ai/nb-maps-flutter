import 'dart:async';

import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('buildFeatureCollection should return a valid feature collection', () {
    // Arrange
    List<Map<String, dynamic>> features = [
      {"name": "Feature 1", "type": "Point"},
      {"name": "Feature 2", "type": "Polygon"},
      {"name": "Feature 3", "type": "LineString"},
    ];

    // Act
    Map<String, dynamic> result = buildFeatureCollection(features);

    // Assert
    expect(result["type"], equals("FeatureCollection"));
    expect(result["features"], equals(features));
  });

  test('getRandomString should return a random string of specified length', () {
    // Arrange
    int length = 8;

    // Act
    String result = getRandomString(length);

    // Assert
    expect(result.length, equals(length));
  });

  test('prints message in debug mode', () {
    var logOutput = <String>[];

    var spec = ZoneSpecification(print: (self, parent, zone, message) {
      logOutput.add(message);
    });

    Zone.current.fork(specification: spec).run(() {
      debugLog('Test message');
    });

    expect(logOutput, contains('Test message'));
  });
}
