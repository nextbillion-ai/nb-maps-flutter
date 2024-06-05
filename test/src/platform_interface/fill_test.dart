import 'package:test/test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  group('translateFillOptions', () {
    test('should translate fill options correctly', () {
      // Arrange
      FillOptions options = FillOptions(
        fillOpacity: 0.5,
        fillColor: '#FF0000',
        fillOutlineColor: '#000000',
        fillPattern: 'pattern',
        geometry: [
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
        ],
        draggable: true,
      );
      LatLng delta = LatLng(1.0, 1.0);

      // Act
      FillOptions result = translateFillOptions(options, delta);

      // Assert
      expect(result.fillOpacity, equals(options.fillOpacity));
      expect(result.fillColor, equals(options.fillColor));
      expect(result.fillOutlineColor, equals(options.fillOutlineColor));
      expect(result.fillPattern, equals(options.fillPattern));
      expect(result.geometry, isNotNull);
      expect(result.geometry!.length, equals(options.geometry!.length));
      expect(result.geometry![0].length, equals(options.geometry![0].length));
      expect(result.geometry![0][0].latitude,
          equals(options.geometry![0][0].latitude + delta.latitude));
      expect(result.geometry![0][0].longitude,
          equals(options.geometry![0][0].longitude + delta.longitude));
      expect(result.geometry![0][1].latitude,
          equals(options.geometry![0][1].latitude + delta.latitude));
      expect(result.geometry![0][1].longitude,
          equals(options.geometry![0][1].longitude + delta.longitude));
      expect(result.draggable, equals(options.draggable));
    });

    test('should return options as is if geometry is null', () {
      // Arrange
      FillOptions options = FillOptions();

      // Act
      FillOptions result = translateFillOptions(options, LatLng(1.0, 1.0));

      // Assert
      expect(result, equals(options));
    });
  });

  group('Fill', () {
    test('should create Fill instance correctly', () {
      // Arrange
      String id = 'fill_1';
      FillOptions options = FillOptions(
        fillOpacity: 0.5,
        fillColor: '#FF0000',
        fillOutlineColor: '#000000',
        fillPattern: 'pattern',
        geometry: [
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
        ],
        draggable: true,
      );
      Map<String, dynamic>? data = {'key': 'value'};

      // Act
      Fill fill = Fill(id, options, data);

      // Assert
      expect(fill.id, equals(id));
      expect(fill.options, equals(options));
      expect(fill.data, equals(data));
    });

    test('should translate fill options correctly', () {
      // Arrange
      String id = 'fill_1';
      FillOptions options = FillOptions(
        fillOpacity: 0.5,
        fillColor: '#FF0000',
        fillOutlineColor: '#000000',
        fillPattern: 'pattern',
        geometry: [
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
        ],
        draggable: true,
      );
      Map<String, dynamic>? data = {'key': 'value'};
      Fill fill = Fill(id, options, data);
      LatLng delta = LatLng(1.0, 1.0);

      // Act
      fill.translate(delta);

      // Assert
      expect(fill.options.fillOpacity, equals(options.fillOpacity));
      expect(fill.options.fillColor, equals(options.fillColor));
      expect(fill.options.fillOutlineColor, equals(options.fillOutlineColor));
      expect(fill.options.fillPattern, equals(options.fillPattern));
      expect(fill.options.geometry, isNotNull);
      expect(fill.options.geometry!.length, equals(options.geometry!.length));
      expect(fill.options.geometry![0].length,
          equals(options.geometry![0].length));
      expect(fill.options.geometry![0][0].latitude,
          equals(options.geometry![0][0].latitude + delta.latitude));
      expect(fill.options.geometry![0][0].longitude,
          equals(options.geometry![0][0].longitude + delta.longitude));
      expect(fill.options.geometry![0][1].latitude,
          equals(options.geometry![0][1].latitude + delta.latitude));
      expect(fill.options.geometry![0][1].longitude,
          equals(options.geometry![0][1].longitude + delta.longitude));
      expect(fill.options.draggable, equals(options.draggable));
    });

    test('should convert to GeoJSON correctly', () {
      // Arrange
      String id = 'fill_1';
      FillOptions options = FillOptions(
        fillOpacity: 0.5,
        fillColor: '#FF0000',
        fillOutlineColor: '#000000',
        fillPattern: 'pattern',
        geometry: [
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
        ],
        draggable: true,
      );
      Fill fill = Fill(id, options);

      // Act
      Map<String, dynamic> result = fill.toGeoJson();

      // Assert
      expect(result['type'], equals('Feature'));
      expect(result['properties']['id'], equals(id));
      expect(result['geometry']['type'], equals('Polygon'));
      expect(result['geometry']['coordinates'], isNotNull);
      expect(result['geometry']['coordinates'].length,
          equals(options.geometry!.length));
      expect(result['geometry']['coordinates'][0].length,
          equals(options.geometry![0].length));
      expect(result['geometry']['coordinates'][0][0][0],
          equals(options.geometry![0][0].longitude));
      expect(result['geometry']['coordinates'][0][0][1],
          equals(options.geometry![0][0].latitude));
      expect(result['geometry']['coordinates'][0][1][0],
          equals(options.geometry![0][1].longitude));
      expect(result['geometry']['coordinates'][0][1][1],
          equals(options.geometry![0][1].latitude));
    });
  });

  group('FillOptions', () {
    test('should create FillOptions instance correctly', () {
      // Arrange
      double fillOpacity = 0.5;
      String fillColor = '#FF0000';
      String fillOutlineColor = '#000000';
      String fillPattern = 'pattern';
      List<List<LatLng>> geometry = [
        [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
      ];
      bool draggable = true;

      // Act
      FillOptions options = FillOptions(
        fillOpacity: fillOpacity,
        fillColor: fillColor,
        fillOutlineColor: fillOutlineColor,
        fillPattern: fillPattern,
        geometry: geometry,
        draggable: draggable,
      );

      // Assert
      expect(options.fillOpacity, equals(fillOpacity));
      expect(options.fillColor, equals(fillColor));
      expect(options.fillOutlineColor, equals(fillOutlineColor));
      expect(options.fillPattern, equals(fillPattern));
      expect(options.geometry, equals(geometry));
      expect(options.draggable, equals(draggable));
    });

    test('should create default FillOptions instance correctly', () {
      // Arrange

      // Act
      FillOptions options = FillOptions.defaultOptions;

      // Assert
      expect(options.fillOpacity, isNull);
      expect(options.fillColor, isNull);
      expect(options.fillOutlineColor, isNull);
      expect(options.fillPattern, isNull);
      expect(options.geometry, isNull);
      expect(options.draggable, isNull);
    });

    test('should copy FillOptions correctly', () {
      // Arrange
      FillOptions options = FillOptions(
        fillOpacity: 0.5,
        fillColor: '#FF0000',
        fillOutlineColor: '#000000',
        fillPattern: 'pattern',
        geometry: [
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
        ],
        draggable: true,
      );
      FillOptions changes = FillOptions(
        fillOpacity: 0.8,
        fillColor: '#00FF00',
        fillOutlineColor: '#FFFFFF',
        fillPattern: 'newPattern',
        geometry: [
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
          [
            LatLng(37.7749, -122.4194),
            LatLng(37.8095, -122.3927),
          ],
        ],
        draggable: false,
      );

      // Act
      FillOptions result = options.copyWith(changes);

      // Assert
      expect(result.fillOpacity, equals(changes.fillOpacity));
      expect(result.fillColor, equals(changes.fillColor));
      expect(result.fillOutlineColor, equals(changes.fillOutlineColor));
      expect(result.fillPattern, equals(changes.fillPattern));
      expect(result.geometry, equals(changes.geometry));
      expect(result.draggable, equals(changes.draggable));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      double fillOpacity = 0.5;
      String fillColor = '#FF0000';
      String fillOutlineColor = '#000000';
      String fillPattern = 'pattern';
      List<List<LatLng>> geometry = [
        [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
      ];
      bool draggable = true;
      FillOptions options = FillOptions(
        fillOpacity: fillOpacity,
        fillColor: fillColor,
        fillOutlineColor: fillOutlineColor,
        fillPattern: fillPattern,
        geometry: geometry,
        draggable: draggable,
      );

      // Act
      dynamic result = options.toJson();

      // Assert
      expect(result['fillOpacity'], equals(fillOpacity));
      expect(result['fillColor'], equals(fillColor));
      expect(result['fillOutlineColor'], equals(fillOutlineColor));
      expect(result['fillPattern'], equals(fillPattern));
      expect(result['geometry'], isNotNull);
      expect(result['geometry'].length, equals(geometry.length));
      expect(result['geometry'][0].length, equals(geometry[0].length));
      expect(result['geometry'][0][0][0], equals(geometry[0][0].latitude));
      expect(result['geometry'][0][0][1], equals(geometry[0][0].longitude));
      expect(result['geometry'][0][1][0], equals(geometry[0][1].latitude));
      expect(result['geometry'][0][1][1], equals(geometry[0][1].longitude));
      expect(result['draggable'], equals(draggable));
    });

    test('should convert to GeoJSON correctly', () {
      // Arrange
      double fillOpacity = 0.5;
      String fillColor = '#FF0000';
      String fillOutlineColor = '#000000';
      String fillPattern = 'pattern';
      List<List<LatLng>> geometry = [
        [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
      ];
      FillOptions options = FillOptions(
        fillOpacity: fillOpacity,
        fillColor: fillColor,
        fillOutlineColor: fillOutlineColor,
        fillPattern: fillPattern,
        geometry: geometry,
      );

      // Act
      Map<String, dynamic> result = options.toGeoJson();

      // Assert
      expect(result['type'], equals('Feature'));
      expect(result['properties'], isNotNull);
      expect(result['properties']['fillOpacity'], equals(fillOpacity));
      expect(result['properties']['fillColor'], equals(fillColor));
      expect(
          result['properties']['fillOutlineColor'], equals(fillOutlineColor));
      expect(result['properties']['fillPattern'], equals(fillPattern));
      expect(result['geometry'], isNotNull);
      expect(result['geometry']['type'], equals('Polygon'));
      expect(result['geometry']['coordinates'], isNotNull);
      expect(result['geometry']['coordinates'].length, equals(geometry.length));
      expect(result['geometry']['coordinates'][0].length,
          equals(geometry[0].length));
      expect(result['geometry']['coordinates'][0][0][0],
          equals(geometry[0][0].longitude));
      expect(result['geometry']['coordinates'][0][0][1],
          equals(geometry[0][0].latitude));
      expect(result['geometry']['coordinates'][0][1][0],
          equals(geometry[0][1].longitude));
      expect(result['geometry']['coordinates'][0][1][1],
          equals(geometry[0][1].latitude));
    });
  });
}
