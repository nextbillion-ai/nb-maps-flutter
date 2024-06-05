import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('NbMapStyles constants should have correct URLs', () {
    expect(
        NbMapStyles.NBMAP_STREETS,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-light"));
    expect(
        NbMapStyles.OUTDOORS,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-light"));
    expect(
        NbMapStyles.LIGHT,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-light"));
    expect(
        NbMapStyles.EMPTY,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-light"));
    expect(
        NbMapStyles.DARK,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-dark"));
    expect(
        NbMapStyles.SATELLITE,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-satellite"));
    expect(
        NbMapStyles.SATELLITE_STREETS,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-satellite"));
    expect(
        NbMapStyles.TRAFFIC_DAY,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-light&traffic_incidents=2/incidents_light&traffic_flow=2/flow_relative-light"));
    expect(
        NbMapStyles.TRAFFIC_NIGHT,
        equals(
            "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-dark&traffic_incidents=2/incidents_dark&traffic_flow=2/flow_relative-dark"));
  });

  test('CameraTargetBounds should have correct values', () {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(37.7749, -122.4194),
      northeast: LatLng(37.8095, -122.3927),
    );
    CameraTargetBounds cameraTargetBounds = CameraTargetBounds(bounds);

    expect(cameraTargetBounds.bounds, equals(bounds));
    expect(cameraTargetBounds.toJson(), equals([bounds.toList()]));
    expect(cameraTargetBounds.toString(),
        equals('CameraTargetBounds(bounds: $bounds)'));
  });

  test('CameraTargetBounds should have unbounded value', () {
    CameraTargetBounds cameraTargetBounds = CameraTargetBounds.unbounded;

    expect(cameraTargetBounds.bounds, isNull);
    expect(cameraTargetBounds.toJson(), equals([null]));
    expect(cameraTargetBounds.toString(),
        equals('CameraTargetBounds(bounds: null)'));
  });

  test('MinMaxZoomPreference should have correct values', () {
    double minZoom = 10.0;
    double maxZoom = 15.0;
    MinMaxZoomPreference minMaxZoomPreference =
        MinMaxZoomPreference(minZoom, maxZoom);

    expect(minMaxZoomPreference.minZoom, equals(minZoom));
    expect(minMaxZoomPreference.maxZoom, equals(maxZoom));
    expect(minMaxZoomPreference.toJson(), equals([minZoom, maxZoom]));
    expect(minMaxZoomPreference.toString(),
        equals('MinMaxZoomPreference(minZoom: $minZoom, maxZoom: $maxZoom)'));
  });

  test('MinMaxZoomPreference should have unbounded values', () {
    MinMaxZoomPreference minMaxZoomPreference = MinMaxZoomPreference.unbounded;

    expect(minMaxZoomPreference.minZoom, isNull);
    expect(minMaxZoomPreference.maxZoom, isNull);
    expect(minMaxZoomPreference.toJson(), equals([null, null]));
    expect(minMaxZoomPreference.toString(),
        equals('MinMaxZoomPreference(minZoom: null, maxZoom: null)'));
  });

  group('CameraTargetBounds', () {
    test('== returns true for identical objects', () {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(37.7749, -122.4194),
        northeast: LatLng(37.8095, -122.3927),
      );
      CameraTargetBounds bounds1 = CameraTargetBounds(bounds);
      final bounds2 = bounds1;

      expect(bounds1 == bounds2, isTrue);
    });

    test('== returns false for different types', () {
      final bounds = CameraTargetBounds.unbounded;
      final other = 'not a CameraTargetBounds';

      expect(bounds == other, isFalse);
    });

    test('== returns true for equal bounds', () {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(37.7749, -122.4194),
        northeast: LatLng(37.8095, -122.3927),
      );
      final bounds1 = CameraTargetBounds(bounds);
      final bounds2 = CameraTargetBounds(bounds);

      expect(bounds1 == bounds2, isTrue);
    });

    test('== returns false for unequal bounds', () {
      LatLngBounds latLngBounds = LatLngBounds(
        southwest: LatLng(37.7749, -122.4194),
        northeast: LatLng(37.8095, -122.3927),
      );
      final bounds1 = CameraTargetBounds(latLngBounds);

      LatLngBounds latLngBounds2 = LatLngBounds(
          southwest: LatLng(37.7649, -122.5194),
          northeast: LatLng(37.8095, -122.3727));
      final bounds2 = CameraTargetBounds(latLngBounds2);

      expect(bounds1 == bounds2, isFalse);
    });

    test('hashCode returns consistent value', () {
      LatLngBounds latLngBounds = LatLngBounds(
        southwest: LatLng(37.7749, -122.4194),
        northeast: LatLng(37.8095, -122.3927),
      );
      final bounds = CameraTargetBounds(latLngBounds);

      final hashCode1 = bounds.hashCode;
      final hashCode2 = bounds.hashCode;

      expect(hashCode1, hashCode2);
    });

    test('hashCode returns different values for different objects', () {
      LatLngBounds latLngBounds = LatLngBounds(
        southwest: LatLng(37.7749, -122.4194),
        northeast: LatLng(37.8095, -122.3927),
      );
      final bounds1 = CameraTargetBounds(latLngBounds);

      LatLngBounds latLngBounds2 = LatLngBounds(
          southwest: LatLng(37.7649, -122.5194),
          northeast: LatLng(37.8095, -122.3727));
      final bounds2 = CameraTargetBounds(latLngBounds2);

      expect(bounds1.hashCode, isNot(equals(bounds2.hashCode)));
    });
  });

  group('MinMaxZoomPreference', () {
    test('== returns true for identical objects', () {
      double minZoom = 10.0;
      double maxZoom = 15.0;
      MinMaxZoomPreference zoomPreference1 =
          MinMaxZoomPreference(minZoom, maxZoom);

      final zoomPreference2 = zoomPreference1;

      expect(zoomPreference1 == zoomPreference2, isTrue);
    });

    test('== returns false for different types', () {
      double minZoom = 10.0;
      double maxZoom = 15.0;
      MinMaxZoomPreference zoomPreference =
          MinMaxZoomPreference(minZoom, maxZoom);

      final other = 'not a MinMaxZoomPreference';

      expect(zoomPreference == other, isFalse);
    });

    test('== returns true for equal minZoom and maxZoom', () {
      double minZoom = 10.0;
      double maxZoom = 15.0;
      final zoomPreference1 = MinMaxZoomPreference(minZoom, maxZoom);
      final zoomPreference2 = MinMaxZoomPreference(minZoom, maxZoom);
      expect(zoomPreference1 == zoomPreference2, isTrue);
    });

    test('== returns false for unequal minZoom and maxZoom', () {
      double minZoom = 10.0;
      double maxZoom = 15.0;
      final MinMaxZoomPreference zoomPreference1 =
          MinMaxZoomPreference(minZoom, maxZoom);

      final zoomPreference2 =
          MinMaxZoomPreference(minZoom + 1.0, maxZoom + 1.0);

      expect(zoomPreference1 == zoomPreference2, isFalse);
    });
    test('hashCode returns consistent value', () {
      double minZoom = 10.0;
      double maxZoom = 15.0;
      final zoomPreference = MinMaxZoomPreference(minZoom, maxZoom);

      final hashCode1 = zoomPreference.hashCode;
      final hashCode2 = zoomPreference.hashCode;

      expect(hashCode1, hashCode2);
    });

    test('hashCode returns different values for different objects', () {
      double minZoom = 10.0;
      double maxZoom = 15.0;
      final MinMaxZoomPreference zoomPreference1 =
          MinMaxZoomPreference(minZoom, maxZoom);

      final zoomPreference2 =
          MinMaxZoomPreference(minZoom + 1.0, maxZoom + 1.0);

      expect(zoomPreference1.hashCode, isNot(equals(zoomPreference2.hashCode)));
    });
  });
}
