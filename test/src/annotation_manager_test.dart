import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

import 'global_test.mocks.dart';

void main() {
  late MethodChannel mockMethodChannel;
  late MethodChannelNbMapsGl nbMapsGlPlatform;
  late NextbillionMapController controller;
  late LineManager lineManager;
  late FillManager fillManager;
  late CircleManager circleManager;
  late SymbolManager symbolManager;

  setUp(() {
    final initialCameraPosition = CameraPosition(target: LatLng(0.0, 0.0));
    final annotationOrder = <AnnotationType>[];
    final annotationConsumeTapEvents = <AnnotationType>[];

    mockMethodChannel = MockMethodChannel();
    //source#setFeature
    when(mockMethodChannel.invokeMethod('source#setFeature', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('source#setFeatureState', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('source#setGeoJson', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('source#addGeoJson', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('lineLayer#add', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('symbolLayer#add', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('circleLayer#add', any))
        .thenAnswer((_) async => null);

    when(mockMethodChannel.invokeMethod('fillLayer#add', any))
        .thenAnswer((_) async => null);

    nbMapsGlPlatform = MethodChannelNbMapsGl();
    nbMapsGlPlatform.setTestingMethodChanenl(mockMethodChannel);
    controller = NextbillionMapController(
        nbMapsGlPlatform: nbMapsGlPlatform,
        initialCameraPosition: initialCameraPosition,
        annotationOrder: annotationOrder,
        annotationConsumeTapEvents: annotationConsumeTapEvents);

    lineManager = LineManager(controller);
    fillManager = FillManager(controller);
    circleManager = CircleManager(controller);
    symbolManager = SymbolManager(controller);
  });

  group('LineManager', () {
    test('Add a line annotation', () async {
      // Arrange
      final lineOptions = LineOptions(
        lineJoin: 'round',
        lineOpacity: 0.8,
        lineColor: '#FF0000',
        lineWidth: 2.0,
        lineGapWidth: 0.0,
        lineOffset: 0.0,
        lineBlur: 0.0,
        linePattern: 'solid',
        geometry: [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
        draggable: true,
      );
      final line = Line('line1', lineOptions);

      // Act
      await lineManager.add(line);

      // Assert
      expect(lineManager.annotations.contains(line), isTrue);
    });

    test('Remove a line annotation', () async {
      // Arrange
      final lineOptions = LineOptions(
        lineJoin: 'round',
        lineOpacity: 0.8,
        lineColor: '#FF0000',
        lineWidth: 2.0,
        lineGapWidth: 0.0,
        lineOffset: 0.0,
        lineBlur: 0.0,
        linePattern: 'solid',
        geometry: [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
        draggable: true,
      );
      final line = Line('line1', lineOptions);

      await lineManager.add(line);

      // Act
      await lineManager.remove(line);

      // Assert
      expect(lineManager.annotations.contains(line), isFalse);
    });

    test('Set line annotation', () async {
      // Arrange
      final lineOptions = LineOptions(
        lineJoin: 'round',
        lineOpacity: 0.8,
        lineColor: '#FF0000',
        lineWidth: 2.0,
        lineGapWidth: 0.0,
        lineOffset: 0.0,
        lineBlur: 0.0,
        linePattern: 'solid',
        geometry: [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
        draggable: true,
      );

      final line = Line('line1', lineOptions);
      await lineManager.add(line);

      // Act
      final changes = LineOptions(
        lineJoin: 'round',
        lineOpacity: 0.8,
        lineColor: '#FFFFFF',
        lineWidth: 2.0,
        lineGapWidth: 0.0,
        lineOffset: 0.0,
        lineBlur: 0.0,
        linePattern: 'solid',
        geometry: [
          LatLng(37.7749, -122.4194),
          LatLng(37.8095, -122.3927),
        ],
        draggable: true,
      );
      line.options = line.options.copyWith(changes);
      await lineManager.set(line);

      // Assert
      expect(lineManager.annotations.first.options.lineColor, '#FFFFFF');
    });
  });

  group('FillManager', () {
    test('Add a fill annotation', () async {
      // Arrange
      FillOptions fillOptions = FillOptions(
        fillColor: '#FF0000',
        fillOpacity: 0.5,
        fillOutlineColor: '#0000FF',
        fillPattern: 'solid',
        geometry: [
          [LatLng(37.7749, -122.4194), LatLng(37.8095, -122.3927)]
        ],
        draggable: true,
      );
      Fill fill = Fill('fill1', fillOptions);

      // Act
      await fillManager.add(fill);

      // Assert
      expect(fillManager.annotations.contains(fill), isTrue);
    });

    test('Remove a fill annotation', () async {
      // Arrange
      FillOptions fillOptions = FillOptions(
        fillColor: '#FF0000',
        fillOpacity: 0.5,
        fillOutlineColor: '#0000FF',
        fillPattern: 'solid',
        geometry: [
          [LatLng(37.7749, -122.4194), LatLng(37.8095, -122.3927)]
        ],
        draggable: true,
      );

      Fill fill = Fill('fill1', fillOptions);

      await fillManager.add(fill);

      // Act
      await fillManager.remove(fill);

      // Assert
      expect(fillManager.annotations.contains(fill), isFalse);
    });

    test('Set fill annotation', () async {
      // Arrange
      FillOptions fillOptions = FillOptions(
        fillColor: '#FF0000',
        fillOpacity: 0.5,
        fillOutlineColor: '#0000FF',
        fillPattern: 'solid',
        geometry: [
          [LatLng(37.7749, -122.4194), LatLng(37.8095, -122.3927)]
        ],
        draggable: true,
      );
      Fill fill = Fill('fill1', fillOptions);
      fillManager.add(fill);

      // Act
      FillOptions changes = FillOptions(
        fillColor: '#FFFFFF',
        fillOpacity: 0.5,
        fillOutlineColor: '#FFFFFF',
        fillPattern: 'solid',
        geometry: [
          [LatLng(37.7749, -122.4194), LatLng(37.8095, -122.3927)]
        ],
        draggable: true,
      );
      fill.options = fill.options.copyWith(changes);
      await fillManager.set(fill);

      // Assert
      expect(fillManager.annotations.first.options.fillColor, '#FFFFFF');
    });
  });

  group('CircleManager', () {
    test('Add a circle annotation', () async {
      // Arrange
      CircleOptions circleOptions = CircleOptions(
        circleColor: '#FF0000',
        circleRadius: 10.0,
        circleStrokeColor: '#0000FF',
        circleStrokeWidth: 2.0,
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );
      Circle circle = Circle('circle1', circleOptions);

      // Act
      await circleManager.add(circle);

      // Assert
      expect(circleManager.annotations.contains(circle), isTrue);
    });

    test('Remove a circle annotation', () async {
      // Arrange
      CircleOptions circleOptions = CircleOptions(
        circleColor: '#FF0000',
        circleRadius: 10.0,
        circleStrokeColor: '#0000FF',
        circleStrokeWidth: 2.0,
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );
      Circle circle = Circle('circle1', circleOptions);
      await circleManager.add(circle);

      // Act
      await circleManager.remove(circle);

      // Assert
      expect(circleManager.annotations.contains(circle), isFalse);
    });

    test('Set circle annotation', () async {
      // Arrange
      CircleOptions circleOptions = CircleOptions(
        circleColor: '#FF0000',
        circleRadius: 10.0,
        circleStrokeColor: '#0000FF',
        circleStrokeWidth: 2.0,
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );
      Circle circle = Circle('circle1', circleOptions);

      await circleManager.add(circle);

      // Act
      CircleOptions changes = CircleOptions(
        circleColor: '#0000FF',
        circleRadius: 10.0,
        circleStrokeColor: '#0000FF',
        circleStrokeWidth: 2.0,
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );
      circle.options = circle.options.copyWith(changes);
      await circleManager.set(circle);

      // Assert
      expect(circleManager.annotations.first.options.circleColor, '#0000FF');
    });
  });

  group('SymbolManager', () {
    test('Add a symbol annotation', () async {
      // Arrange
      SymbolOptions symbolOptions = SymbolOptions(
        iconSize: 10,
        iconImage: 'iconImage',
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );

      Symbol symbol = Symbol('symbol1', symbolOptions);

      // Act
      await symbolManager.add(symbol);

      // Assert
      expect(symbolManager.annotations.contains(symbol), isTrue);
    });

    test('Remove a symbol annotation', () async {
      // Arrange
      SymbolOptions symbolOptions = SymbolOptions(
        iconSize: 10,
        iconImage: 'iconImage',
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );

      Symbol symbol = Symbol('symbol1', symbolOptions);
      await symbolManager.add(symbol);

      // Act
      await symbolManager.remove(symbol);

      // Assert
      expect(symbolManager.annotations.contains(symbol), isFalse);
    });

    test('Set symbol annotation', () async {
      // Arrange
      SymbolOptions symbolOptions = SymbolOptions(
        iconSize: 10,
        iconImage: 'iconImage',
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );

      Symbol symbol = Symbol('symbol1', symbolOptions);
      await symbolManager.add(symbol);

      // Act
      SymbolOptions changes = SymbolOptions(
        iconSize: 20,
        iconImage: 'iconImage',
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );
      symbol.options = symbol.options.copyWith(changes);
      await symbolManager.set(symbol);

      // Assert
      expect(symbolManager.annotations.first.options.iconSize, 20);
    });

    test('test setIconAllowOverlap', () async {
      // Arrange
      SymbolOptions symbolOptions = SymbolOptions(
        iconSize: 10,
        iconImage: 'iconImage',
        geometry: LatLng(37.7749, -122.4194),
        draggable: true,
      );

      Symbol symbol = Symbol('symbol1', symbolOptions);
      await symbolManager.clear();
      await symbolManager.add(symbol);

      // Act
      await symbolManager.setIconAllowOverlap(true);
      await symbolManager.setTextAllowOverlap(true);
      await symbolManager.setIconIgnorePlacement(true);
      await symbolManager.setTextIgnorePlacement(true);

      // Assert
      SymbolLayerProperties symbolLayerProperties =
          symbolManager.allLayerProperties.first as SymbolLayerProperties;

      expect(symbolLayerProperties.iconAllowOverlap, true);
      expect(symbolLayerProperties.textAllowOverlap, true);
      expect(symbolLayerProperties.iconIgnorePlacement, true);
      expect(symbolLayerProperties.textIgnorePlacement, true);
    });
  });
}
