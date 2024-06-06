import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  testWidgets('NBMap Widget test', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NBMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(1.3, 108.2), zoom: 15.0),
        ),
      ),
    ));

    expect(find.byType(NBMap), findsOne);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NBMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(37, 128.2), zoom: 14.0),
        ),
      ),
    ));

    expect(find.byType(NBMap), findsOne);
  });
}
