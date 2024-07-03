import 'package:flutter/widgets.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('verify dispose functionalities', () {
    WidgetsFlutterBinding.ensureInitialized();
    NbMapsGlPlatform platform = MethodChannelNbMapsGl();
    expect(platform, isNotNull);
    platform.onInfoWindowTappedPlatform.add((String str) {
      return null;
    });
    expect(platform.onInfoWindowTappedPlatform.length, equals(1));
    platform.initPlatform(1);
    platform.dispose();

    expect(platform.onInfoWindowTappedPlatform.length, equals(0));

    /**å
    onInfoWindowTappedPlatform.clear();
    onFeatureTappedPlatform.clear();
    onFeatureDraggedPlatform.clear();
    onCameraMoveStartedPlatform.clear();
    onCameraMovePlatform.clear();
    onCameraIdlePlatform.clear();
    onMapStyleLoadedPlatform.clear();

    onMapClickPlatform.clear();
    onMapLongClickPlatform.clear();
    onAttributionClickPlatform.clear();
    onCameraTrackingChangedPlatform.clear();
    onCameraTrackingDismissedPlatform.clear();
    onMapIdlePlatform.clear();
    onUserLocationUpdatedPlatform.clear();
     */
  });
}
