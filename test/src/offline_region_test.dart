import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('OfflineRegionDefinition should convert to map correctly', () {
    // Arrange
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(37.7749, -122.4194),
      northeast: LatLng(37.8095, -122.3927),
    );
    String mapStyleUrl = "https://example.com/mapstyle";
    double minZoom = 10.0;
    double maxZoom = 15.0;
    bool includeIdeographs = true;
    OfflineRegionDefinition definition = OfflineRegionDefinition(
      bounds: bounds,
      mapStyleUrl: mapStyleUrl,
      minZoom: minZoom,
      maxZoom: maxZoom,
      includeIdeographs: includeIdeographs,
    );

    // Act
    Map<String, dynamic> result = definition.toMap();

    // Assert
    expect(result['bounds'], equals(bounds.toList()));
    expect(result['mapStyleUrl'], equals(mapStyleUrl));
    expect(result['minZoom'], equals(minZoom));
    expect(result['maxZoom'], equals(maxZoom));
    expect(result['includeIdeographs'], equals(includeIdeographs));
  });

  test('OfflineRegionDefinition should convert from map correctly', () {
    // Arrange
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(37.7749, -122.4194),
      northeast: LatLng(37.8095, -122.3927),
    );
    String mapStyleUrl = "https://example.com/mapstyle";
    double minZoom = 10.0;
    double maxZoom = 15.0;
    bool includeIdeographs = true;
    Map<String, dynamic> map = {
      'bounds': bounds.toList(),
      'mapStyleUrl': mapStyleUrl,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'includeIdeographs': includeIdeographs,
    };

    // Act
    OfflineRegionDefinition result = OfflineRegionDefinition.fromMap(map);

    // Assert
    expect(result.bounds, equals(bounds));
    expect(result.mapStyleUrl, equals(mapStyleUrl));
    expect(result.minZoom, equals(minZoom));
    expect(result.maxZoom, equals(maxZoom));
    expect(result.includeIdeographs, equals(includeIdeographs));
  });

  test('OfflineRegion should convert from map correctly', () {
    // Arrange
    int id = 123;
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(37.7749, -122.4194),
      northeast: LatLng(37.8095, -122.3927),
    );
    String mapStyleUrl = "https://example.com/mapstyle";
    double minZoom = 10.0;
    double maxZoom = 15.0;
    bool includeIdeographs = true;
    Map<String, dynamic> definitionMap = {
      'bounds': bounds.toList(),
      'mapStyleUrl': mapStyleUrl,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'includeIdeographs': includeIdeographs,
    };
    Map<String, dynamic> metadata = {"key": "value"};
    Map<String, dynamic> map = {
      'id': id,
      'definition': definitionMap,
      'metadata': metadata,
    };

    // Act
    OfflineRegion result = OfflineRegion.fromMap(map);

    // Assert
    expect(result.id, equals(id));
    expect(result.definition.bounds, equals(bounds));
    expect(result.definition.mapStyleUrl, equals(mapStyleUrl));
    expect(result.definition.minZoom, equals(minZoom));
    expect(result.definition.maxZoom, equals(maxZoom));
    expect(result.definition.includeIdeographs, equals(includeIdeographs));
    expect(result.metadata, equals(metadata));

    expect(
      result.toString(),
      'OfflineRegion, id = 123, definition = ${result.definition}, metadata = ${result.metadata}',
    );
  });
}
