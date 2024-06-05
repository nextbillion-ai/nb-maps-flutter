import 'package:test/test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  group('Symbol', () {
    test('toGeoJson should return the correct GeoJSON representation', () {
      // Arrange
      final options = SymbolOptions(
        iconSize: 1.0,
        iconImage: 'symbol_icon',
        geometry: LatLng(37.7749, -122.4194),
      );
      final symbol = Symbol('symbol_id', options);

      // Act
      final geojson = symbol.toGeoJson();

      // Assert
      expect(symbol.data, isNull);
      expect(geojson['type'], equals('Feature'));
      expect(geojson['properties']['iconSize'], equals(1.0));
      expect(geojson['properties']['iconImage'], equals('symbol_icon'));
      expect(geojson['properties']['id'], equals('symbol_id'));
      expect(geojson['geometry']['type'], equals('Point'));
      expect(geojson['geometry']['coordinates'], equals([-122.4194, 37.7749]));
    });

    test('translate should update the symbol options geometry', () {
      // Arrange
      final options = SymbolOptions(
        geometry: LatLng(37.7749, -122.4194),
      );
      final symbol = Symbol('symbol_id', options);
      final delta = LatLng(0.1, 0.1);

      // Act
      symbol.translate(delta);

      // Assert
      // expect(symbol.options.geometry, equals(LatLng(37.8749, -122.3194)));
      expect(symbol.options.geometry!.latitude, closeTo(37.8749, 0.00001));
      expect(symbol.options.geometry!.longitude, closeTo(-122.3194, 0.00001));
    });
  });

  group('SymbolOptions', () {
    test('toJson should return the correct JSON representation', () {
      // Arrange
      final options = SymbolOptions(
        iconSize: 1.0,
        iconImage: 'symbol_icon',
        geometry: LatLng(37.7749, -122.4194),
      );

      // Act
      final json = options.toJson();

      // Assert
      expect(json['iconSize'], equals(1.0));
      expect(json['iconImage'], equals('symbol_icon'));
      expect(json['geometry'], equals([37.7749, -122.4194]));
    });

    test('toGeoJson should return the correct GeoJSON representation', () {
      // Arrange
      final options = SymbolOptions(
        iconSize: 1.0,
        iconImage: 'symbol_icon',
        geometry: LatLng(37.7749, -122.4194),
      );

      // Act
      final geojson = options.toGeoJson();

      // Assert
      expect(geojson['type'], equals('Feature'));
      expect(geojson['properties']['iconSize'], equals(1.0));
      expect(geojson['properties']['iconImage'], equals('symbol_icon'));
      expect(geojson['geometry']['type'], equals('Point'));
      expect(geojson['geometry']['coordinates'], equals([-122.4194, 37.7749]));
    });

    test('copyWith should create a new SymbolOptions with the given changes',
        () {
      // Arrange
      final options = SymbolOptions(
        iconSize: 1.0,
        iconImage: 'symbol_icon',
        geometry: LatLng(37.7749, -122.4194),
      );
      final changes = SymbolOptions(
        iconSize: 2.0,
        iconImage: 'new_symbol_icon',
      );

      // Act
      final newOptions = options.copyWith(changes);

      // Assert
      expect(newOptions.iconSize, equals(2.0));
      expect(newOptions.iconImage, equals('new_symbol_icon'));
      expect(newOptions.geometry, equals(LatLng(37.7749, -122.4194)));
    });
  });
}
