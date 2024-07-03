import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('test fromList', () {
    List<dynamic> list = [
      [1.0, 2.0],
      [3.0, 4.0],
      [5.0, 6.0],
      [7.0, 8.0]
    ];
    final location = LatLngQuad.fromList(list);
    expect(location, isNotNull);
    expect(location?.topLeft, equals(LatLng(list[0][0], list[0][1])));
    expect(location?.topRight, equals(LatLng(list[1][0], list[1][1])));
    expect(location?.bottomLeft, equals(LatLng(list[3][0], list[3][1])));
    expect(location?.bottomRight, equals(LatLng(list[2][0], list[2][1])));
  });

  test('test fromMultiLatLng', () {
    List<LatLng> list = [
      LatLng(1.0, 2.0),
      LatLng(3.0, 4.0),
      LatLng(5.0, 6.0),
      LatLng(7.0, 8.0)
    ];
    final location = LatLngBounds.fromMultiLatLng(list);
    expect(location, isNotNull);
    expect(location.southwest, equals(list[0]));
    expect(location.northeast, equals(list[3]));
  });
}
