import 'dart:math';

import 'package:test/test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  group('_NextBillionMapOptions', () {
    test('toMap should convert options to a map correctly', () {
      // Arrange
      final options = NextBillionMapOptions(
        compassEnabled: true,
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            southwest: LatLng(37.7749, -122.4194),
            northeast: LatLng(37.8095, -122.3927),
          ),
        ),
        styleString: 'https://example.com/mapstyle',
        minMaxZoomPreference: MinMaxZoomPreference(10.0, 15.0),
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: true,
        doubleClickZoomEnabled: true,
        trackCameraPosition: true,
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.None,
        myLocationRenderMode: MyLocationRenderMode.NORMAL,
        logoViewMargins: Point(10, 10),
        compassViewPosition: CompassViewPosition.BottomLeft,
        compassViewMargins: Point(5, 5),
        attributionButtonPosition: AttributionButtonPosition.BottomRight,
        attributionButtonMargins: Point(5, 5),
      );

      // Act
      final result = options.toMap();

      // Assert
      expect(result['compassEnabled'], equals(true));
      expect(result['cameraTargetBounds'], isNotNull);
      expect(result['styleString'], equals('https://example.com/mapstyle'));
      expect(result['minMaxZoomPreference'], isNotNull);
      expect(result['rotateGesturesEnabled'], equals(true));
      expect(result['scrollGesturesEnabled'], equals(true));
      expect(result['tiltGesturesEnabled'], equals(true));
      expect(result['zoomGesturesEnabled'], equals(true));
      expect(result['doubleClickZoomEnabled'], equals(true));
      expect(result['trackCameraPosition'], equals(true));
      expect(result['myLocationEnabled'], equals(true));
      expect(result['myLocationTrackingMode'],
          equals(MyLocationTrackingMode.None.index));
      expect(result['myLocationRenderMode'],
          equals(MyLocationRenderMode.NORMAL.index));
      expect(result['logoViewMargins'], equals([10, 10]));
      expect(result['compassViewPosition'],
          equals(CompassViewPosition.BottomLeft.index));
      expect(result['compassViewMargins'], equals([5, 5]));
      expect(result['attributionButtonPosition'],
          equals(AttributionButtonPosition.BottomRight.index));
      expect(result['attributionButtonMargins'], equals([5, 5]));
    });

    test('updatesMap should return the updated options as a map', () {
      // Arrange
      final prevOptions = NextBillionMapOptions(
        compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: true,
        doubleClickZoomEnabled: true,
      );
      final newOptions = NextBillionMapOptions(
        compassEnabled: false,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: false,
        doubleClickZoomEnabled: true,
      );

      // Act
      final result = prevOptions.updatesMap(newOptions);

      // Assert
      expect(result['compassEnabled'], equals(false));
      expect(result['scrollGesturesEnabled'], equals(false));
      expect(result['zoomGesturesEnabled'], equals(false));
    });
  });
}
