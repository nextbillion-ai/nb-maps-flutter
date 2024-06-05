import 'dart:ui';

import 'package:test/test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  group('CameraPosition', () {
    test('toMap should convert CameraPosition to a map correctly', () {
      // Arrange
      final cameraPosition = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );

      // Act
      final result = cameraPosition.toMap();

      // Assert
      expect(result['bearing'], equals(90.0));
      expect(result['target'], equals(cameraPosition.target.toJson()));
      expect(result['tilt'], equals(45.0));
      expect(result['zoom'], equals(10.0));
    });

    test('fromMap should convert a map to CameraPosition correctly', () {
      // Arrange
      final json = {
        'bearing': 90.0,
        'target': LatLng(37.7749, -122.4194).toJson(),
        'tilt': 45.0,
        'zoom': 10.0,
      };

      // Act
      final result = CameraPosition.fromMap(json);

      // Assert
      expect(result?.bearing, equals(90.0));
      expect(result?.target, equals(LatLng(37.7749, -122.4194)));
      expect(result?.tilt, equals(45.0));
      expect(result?.zoom, equals(10.0));
    });

    test('CameraPosition instances with the same values should be equal', () {
      // Arrange
      final cameraPosition1 = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );
      final cameraPosition2 = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );

      // Act
      final result = cameraPosition1 == cameraPosition2;

      // Assert
      expect(result, isTrue);
    });

    test(
        'hashCode should return the same value for equal CameraPosition instances',
        () {
      // Arrange
      final cameraPosition1 = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );
      final cameraPosition2 = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );

      // Act
      final hashCode1 = cameraPosition1.hashCode;
      final hashCode2 = cameraPosition2.hashCode;

      // Assert
      expect(hashCode1, equals(hashCode2));
    });

    test('toString should return a string representation of CameraPosition',
        () {
      // Arrange
      final cameraPosition = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );

      // Act
      final result = cameraPosition.toString();

      // Assert
      expect(
        result,
        equals(
            'CameraPosition(bearing: 90.0, target: LatLng(37.7749, -122.4194), tilt: 45.0, zoom: 10.0)'),
      );
    });
  });

  group('CameraUpdate', () {
    test(
        'newCameraPosition should create a CameraUpdate with newCameraPosition action',
        () {
      // Arrange
      final cameraPosition = CameraPosition(
        bearing: 90.0,
        target: LatLng(37.7749, -122.4194),
        tilt: 45.0,
        zoom: 10.0,
      );

      // Act
      final result = CameraUpdate.newCameraPosition(cameraPosition);

      // Assert
      expect(result.toJson(),
          equals(['newCameraPosition', cameraPosition.toMap()]));
    });

    test('newLatLng should create a CameraUpdate with newLatLng action', () {
      // Arrange
      final latLng = LatLng(37.7749, -122.4194);

      // Act
      final result = CameraUpdate.newLatLng(latLng);

      // Assert
      expect(result.toJson(), equals(['newLatLng', latLng.toJson()]));
    });

    test(
        'newLatLngBounds should create a CameraUpdate with newLatLngBounds action',
        () {
      // Arrange
      final bounds = LatLngBounds(
        southwest: LatLng(37.7749, -122.4194),
        northeast: LatLng(37.8095, -122.3927),
      );
      final left = 10.0;
      final top = 20.0;
      final right = 30.0;
      final bottom = 40.0;

      // Act
      final result = CameraUpdate.newLatLngBounds(bounds,
          left: left, top: top, right: right, bottom: bottom);

      // Assert
      expect(
          result.toJson(),
          equals(
              ['newLatLngBounds', bounds.toList(), left, top, right, bottom]));
    });

    test('newLatLngZoom should create a CameraUpdate with newLatLngZoom action',
        () {
      // Arrange
      final latLng = LatLng(37.7749, -122.4194);
      final zoom = 10.0;

      // Act
      final result = CameraUpdate.newLatLngZoom(latLng, zoom);

      // Assert
      expect(result.toJson(), equals(['newLatLngZoom', latLng.toJson(), zoom]));
    });

    test('scrollBy should create a CameraUpdate with scrollBy action', () {
      // Arrange
      final dx = 50.0;
      final dy = 75.0;

      // Act
      final result = CameraUpdate.scrollBy(dx, dy);

      // Assert
      expect(result.toJson(), equals(['scrollBy', dx, dy]));
    });

    test('zoomBy should create a CameraUpdate with zoomBy action', () {
      // Arrange
      final amount = 2.0;
      final focus = Offset(100.0, 200.0);

      // Act
      final result = CameraUpdate.zoomBy(amount, focus);

      // Assert
      expect(
          result.toJson(),
          equals([
            'zoomBy',
            amount,
            [focus.dx, focus.dy]
          ]));
    });

    test('zoomIn should create a CameraUpdate with zoomIn action', () {
      // Act
      final result = CameraUpdate.zoomIn();

      // Assert
      expect(result.toJson(), equals(['zoomIn']));
    });

    test('zoomOut should create a CameraUpdate with zoomOut action', () {
      // Act
      final result = CameraUpdate.zoomOut();

      // Assert
      expect(result.toJson(), equals(['zoomOut']));
    });

    test('zoomTo should create a CameraUpdate with zoomTo action', () {
      // Arrange
      final zoom = 10.0;

      // Act
      final result = CameraUpdate.zoomTo(zoom);

      // Assert
      expect(result.toJson(), equals(['zoomTo', zoom]));
    });

    test('bearingTo should create a CameraUpdate with bearingTo action', () {
      // Arrange
      final bearing = 90.0;

      // Act
      final result = CameraUpdate.bearingTo(bearing);

      // Assert
      expect(result.toJson(), equals(['bearingTo', bearing]));
    });

    test('tiltTo should create a CameraUpdate with tiltTo action', () {
      // Arrange
      final tilt = 45.0;

      // Act
      final result = CameraUpdate.tiltTo(tilt);

      // Assert
      expect(result.toJson(), equals(['tiltTo', tilt]));
    });
  });
}
