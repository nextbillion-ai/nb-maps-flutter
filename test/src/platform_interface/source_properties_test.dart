import 'package:test/test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  group('VectorSourceProperties', () {
    test('toJson should convert VectorSourceProperties to a map correctly', () {
      // Arrange
      VectorSourceProperties properties = VectorSourceProperties(
        url: 'https://example.com/vector',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        scheme: 'tms',
        minzoom: 5,
        maxzoom: 10,
        attribution: 'Map data © OpenStreetMap contributors',
        promoteId: 'sourceLayer.propertyName',
      );

      // Act
      Map<String, dynamic> result = properties.toJson();

      // Assert
      expect(result['type'], equals('vector'));
      expect(result['url'], equals('https://example.com/vector'));
      expect(result['tiles'],
          equals(['https://example.com/tile1', 'https://example.com/tile2']));
      expect(result['bounds'], equals([-90, -180, 90, 180]));
      expect(result['scheme'], equals('tms'));
      expect(result['minzoom'], equals(5));
      expect(result['maxzoom'], equals(10));
      expect(result['attribution'],
          equals('Map data © OpenStreetMap contributors'));
      expect(result['promoteId'], equals('sourceLayer.propertyName'));
    });

    test('fromJson should convert a map to VectorSourceProperties correctly',
        () {
      // Arrange
      Map<String, dynamic> json = {
        'type': 'vector',
        'url': 'https://example.com/vector',
        'tiles': ['https://example.com/tile1', 'https://example.com/tile2'],
        'bounds': [-90.0, -180.0, 90.0, 180.0],
        'scheme': 'tms',
        'minzoom': 5.0,
        'maxzoom': 10.0,
        'attribution': 'Map data © OpenStreetMap contributors',
        'promoteId': 'sourceLayer.propertyName',
      };

      // Act
      VectorSourceProperties result = VectorSourceProperties.fromJson(json);

      // Assert
      expect(result.url, equals('https://example.com/vector'));
      expect(result.tiles,
          equals(['https://example.com/tile1', 'https://example.com/tile2']));
      expect(result.bounds, equals([-90.0, -180.0, 90.0, 180.0]));
      expect(result.scheme, equals('tms'));
      expect(result.minzoom, equals(5));
      expect(result.maxzoom, equals(10));
      expect(
          result.attribution, equals('Map data © OpenStreetMap contributors'));
      expect(result.promoteId, equals('sourceLayer.propertyName'));
    });

    test('copyWith returns a copy with updated values', () {
      VectorSourceProperties properties = VectorSourceProperties(
        url: 'https://example.com/vector',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        scheme: 'tms',
        minzoom: 5,
        maxzoom: 10,
        attribution: 'Map data © OpenStreetMap contributors',
        promoteId: 'sourceLayer.propertyName',
      );

      final copy = properties.copyWith(
        url: "https://example.com/vector_new",
        tiles: ['https://example.com/tile3', 'https://example.com/tile4'],
        bounds: [-91, -181, 89, 179],
        scheme: 'xyz',
        minzoom: 6,
        maxzoom: 11,
        attribution: 'Map data © Nextbillion contributors',
        promoteId: 'sourceLayer.propertyName_new',
      );

      expect(copy.url, isNot(properties.url));
      expect(copy.tiles, isNot(properties.tiles));
      expect(copy.bounds, isNot(properties.bounds));
      expect(copy.scheme, isNot(properties.scheme));
      expect(copy.minzoom, isNot(properties.minzoom));
      expect(copy.maxzoom, isNot(properties.maxzoom));
      expect(copy.attribution, isNot(properties.attribution));
      expect(copy.promoteId, isNot(properties.promoteId));
    });

    test('copyWith returns a copy with unchanged values when not provided', () {
      VectorSourceProperties properties = VectorSourceProperties(
        url: 'https://example.com/vector',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        scheme: 'tms',
        minzoom: 5,
        maxzoom: 10,
        attribution: 'Map data © OpenStreetMap contributors',
        promoteId: 'sourceLayer.propertyName',
      );

      final copy = properties.copyWith();

      expect(copy.url, equals(properties.url));
    });
  });

  group('RasterSourceProperties', () {
    test('toJson should convert RasterSourceProperties to a map correctly', () {
      // Arrange
      RasterSourceProperties properties = RasterSourceProperties(
        url: 'https://example.com/raster',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        minzoom: 5,
        maxzoom: 10,
        tileSize: 256,
        scheme: 'tms',
        attribution: 'Map data © OpenStreetMap contributors',
      );

      // Act
      Map<String, dynamic> result = properties.toJson();

      // Assert
      expect(result['type'], equals('raster'));
      expect(result['url'], equals('https://example.com/raster'));
      expect(result['tiles'],
          equals(['https://example.com/tile1', 'https://example.com/tile2']));
      expect(result['bounds'], equals([-90, -180, 90, 180]));
      expect(result['minzoom'], equals(5));
      expect(result['maxzoom'], equals(10));
      expect(result['tileSize'], equals(256));
      expect(result['scheme'], equals('tms'));
      expect(result['attribution'],
          equals('Map data © OpenStreetMap contributors'));
    });

    test('fromJson should convert a map to RasterSourceProperties correctly',
        () {
      // Arrange
      Map<String, dynamic> json = {
        'type': 'raster',
        'url': 'https://example.com/raster',
        'tiles': ['https://example.com/tile1', 'https://example.com/tile2'],
        'bounds': <double>[-90, -180, 90, 180],
        'minzoom': 5.0,
        'maxzoom': 10.0,
        'tileSize': 256.toDouble(),
        'scheme': 'tms',
        'attribution': 'Map data © OpenStreetMap contributors',
      };

      // Act
      RasterSourceProperties result = RasterSourceProperties.fromJson(json);

      // Assert
      expect(result.url, equals('https://example.com/raster'));
      expect(result.tiles,
          equals(['https://example.com/tile1', 'https://example.com/tile2']));
      expect(result.bounds, equals([-90, -180, 90, 180]));
      expect(result.minzoom, equals(5));
      expect(result.maxzoom, equals(10));
      expect(result.tileSize, equals(256));
      expect(result.scheme, equals('tms'));
      expect(
          result.attribution, equals('Map data © OpenStreetMap contributors'));
    });

    test('copyWith returns a copy with updated values', () {
      RasterSourceProperties properties = RasterSourceProperties(
        url: 'https://example.com/raster',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        minzoom: 5,
        maxzoom: 10,
        tileSize: 256,
        scheme: 'tms',
        attribution: 'Map data © OpenStreetMap contributors',
      );

      final copy = properties.copyWith(
        url: "https://example.com/raster_new",
        tiles: ['https://example.com/tile3', 'https://example.com/tile4'],
        bounds: [-91, -181, 89, 179],
        minzoom: 6,
        maxzoom: 11,
        tileSize: 512,
        scheme: 'xyz',
        attribution: 'Map data © Nextbillion contributors',
      );

      expect(copy.url, isNot(properties.url));
      expect(copy.bounds, isNot(properties.bounds));
    });

    test('copyWith returns a copy with unchanged values when not provided', () {
      RasterSourceProperties properties = RasterSourceProperties(
        url: 'https://example.com/raster',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        minzoom: 5,
        maxzoom: 10,
        tileSize: 256,
        scheme: 'tms',
        attribution: 'Map data © OpenStreetMap contributors',
      );

      final copy = properties.copyWith();

      expect(copy.url, equals(properties.url));
    });
  });

  group('RasterDemSourceProperties', () {
    test('toJson should convert RasterDemSourceProperties to a map correctly',
        () {
      // Arrange
      RasterDemSourceProperties properties = RasterDemSourceProperties(
        url: 'https://example.com/raster-dem',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        minzoom: 5,
        maxzoom: 10,
        tileSize: 256,
        attribution: 'Map data © OpenStreetMap contributors',
        encoding: 'terrarium',
      );

      // Act
      Map<String, dynamic> result = properties.toJson();

      // Assert
      expect(result['type'], equals('raster-dem'));
      expect(result['url'], equals('https://example.com/raster-dem'));
      expect(result['tiles'],
          equals(['https://example.com/tile1', 'https://example.com/tile2']));
      expect(result['bounds'], equals([-90, -180, 90, 180]));
      expect(result['minzoom'], equals(5));
      expect(result['maxzoom'], equals(10));
      expect(result['tileSize'], equals(256));
      expect(result['attribution'],
          equals('Map data © OpenStreetMap contributors'));
      expect(result['encoding'], equals('terrarium'));
    });

    test('fromJson should convert a map to RasterDemSourceProperties correctly',
        () {
      // Arrange
      Map<String, dynamic> json = {
        'type': 'raster-dem',
        'url': 'https://example.com/raster-dem',
        'tiles': ['https://example.com/tile1', 'https://example.com/tile2'],
        'bounds': <double>[-90, -180, 90, 180],
        'minzoom': 5.toDouble(),
        'maxzoom': 10.toDouble(),
        'tileSize': 256.toDouble(),
        'attribution': 'Map data © OpenStreetMap contributors',
        'encoding': 'terrarium',
      };

      // Act
      RasterDemSourceProperties result =
          RasterDemSourceProperties.fromJson(json);

      // Assert
      expect(result.url, equals('https://example.com/raster-dem'));
      expect(result.tiles,
          equals(['https://example.com/tile1', 'https://example.com/tile2']));
      expect(result.bounds, equals([-90, -180, 90, 180]));
      expect(result.minzoom, equals(5));
      expect(result.maxzoom, equals(10));
      expect(result.tileSize, equals(256));
      expect(
          result.attribution, equals('Map data © OpenStreetMap contributors'));
      expect(result.encoding, equals('terrarium'));
    });

    test('copyWith returns a copy with updated values', () {
      RasterDemSourceProperties properties = RasterDemSourceProperties(
        url: 'https://example.com/raster-dem',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        minzoom: 5,
        maxzoom: 10,
        tileSize: 256,
        attribution: 'Map data © OpenStreetMap contributors',
        encoding: 'terrarium',
      );

      final copy = properties.copyWith(
        url: "https://example.com/raster-dem_new",
        tiles: ['https://example.com/tile3', 'https://example.com/tile4'],
        bounds: [-91, -181, 89, 179],
        minzoom: 6,
        maxzoom: 11,
        tileSize: 512,
        attribution: 'Map data © Nextbillion contributors',
        encoding: 'mapbox',
      );

      expect(copy.url, isNot(properties.url));
      expect(copy.tiles, isNot(properties.tiles));
    });

    test('copyWith returns a copy with unchanged values when not provided', () {
      RasterDemSourceProperties properties = RasterDemSourceProperties(
        url: 'https://example.com/raster-dem',
        tiles: ['https://example.com/tile1', 'https://example.com/tile2'],
        bounds: [-90, -180, 90, 180],
        minzoom: 5,
        maxzoom: 10,
        tileSize: 256,
        attribution: 'Map data © OpenStreetMap contributors',
        encoding: 'terrarium',
      );

      final copy = properties.copyWith();

      expect(copy.url, equals(properties.url));
    });
  });

  group('GeojsonSourceProperties', () {
    test('toJson should convert GeojsonSourceProperties to a map correctly',
        () {
      // Arrange
      GeojsonSourceProperties properties = GeojsonSourceProperties(
        data: {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [0, 0]
          }
        },
        maxzoom: 15,
        attribution: 'Map data © OpenStreetMap contributors',
        buffer: 256,
        tolerance: 0.5,
        cluster: true,
        clusterRadius: 50,
        clusterMaxZoom: 14,
        clusterProperties: {
          'sum': [
            '+',
            ['accumulated'],
            ['get', 'scalerank']
          ]
        },
        lineMetrics: true,
        generateId: true,
        promoteId: 'sourceLayer.propertyName',
      );

      // Act
      Map<String, dynamic> result = properties.toJson();

      // Assert
      expect(result['type'], equals('geojson'));
      expect(
          result['data'],
          equals({
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [0, 0]
            }
          }));
      expect(result['maxzoom'], equals(15));
      expect(result['attribution'],
          equals('Map data © OpenStreetMap contributors'));
      expect(result['buffer'], equals(256));
      expect(result['tolerance'], equals(0.5));
      expect(result['cluster'], equals(true));
      expect(result['clusterRadius'], equals(50));
      expect(result['clusterMaxZoom'], equals(14));
      expect(
          result['clusterProperties'],
          equals({
            'sum': [
              '+',
              ['accumulated'],
              ['get', 'scalerank']
            ]
          }));
      expect(result['lineMetrics'], equals(true));
      expect(result['generateId'], equals(true));
      expect(result['promoteId'], equals('sourceLayer.propertyName'));
    });

    test('fromJson should convert a map to GeojsonSourceProperties correctly',
        () {
      // Arrange
      Map<String, dynamic> json = {
        'type': 'geojson',
        'data': {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [0, 0]
          }
        },
        'maxzoom': 15.toDouble(),
        'attribution': 'Map data © OpenStreetMap contributors',
        'buffer': 256.toDouble(),
        'tolerance': 0.5,
        'cluster': true,
        'clusterRadius': 50.toDouble(),
        'clusterMaxZoom': 14.toDouble(),
        'clusterProperties': {
          'sum': [
            '+',
            ['accumulated'],
            ['get', 'scalerank']
          ]
        },
        'lineMetrics': true,
        'generateId': true,
        'promoteId': 'sourceLayer.propertyName',
      };

      // Act
      GeojsonSourceProperties result = GeojsonSourceProperties.fromJson(json);

      // Assert
      expect(
          result.data,
          equals({
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [0, 0]
            }
          }));
      expect(result.maxzoom, equals(15));
      expect(
          result.attribution, equals('Map data © OpenStreetMap contributors'));
      expect(result.buffer, equals(256));
      expect(result.tolerance, equals(0.5));
      expect(result.cluster, equals(true));
      expect(result.clusterRadius, equals(50));
      expect(result.clusterMaxZoom, equals(14));
      expect(
          result.clusterProperties,
          equals({
            'sum': [
              '+',
              ['accumulated'],
              ['get', 'scalerank']
            ]
          }));
      expect(result.lineMetrics, equals(true));
      expect(result.generateId, equals(true));
      expect(result.promoteId, equals('sourceLayer.propertyName'));
    });

    test('copyWith returns a copy with updated values', () {
      GeojsonSourceProperties properties = GeojsonSourceProperties(
        data: {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [0, 0]
          }
        },
        maxzoom: 15,
        attribution: 'Map data © OpenStreetMap contributors',
        buffer: 256,
        tolerance: 0.5,
        cluster: true,
        clusterRadius: 50,
        clusterMaxZoom: 14,
        clusterProperties: {
          'sum': [
            '+',
            ['accumulated'],
            ['get', 'scalerank']
          ]
        },
        lineMetrics: true,
        generateId: true,
        promoteId: 'sourceLayer.propertyName',
      );

      final copy = properties.copyWith(
          data: {},
          maxzoom: 18,
          attribution: 'Map data © Nextbillion contributors',
          buffer: 512,
          tolerance: 0.8,
          cluster: false,
          clusterRadius: 40,
          clusterMaxZoom: 16,
          clusterProperties: '{}',
          lineMetrics: false,
          generateId: false,
          promoteId: 'sourceLayer.propertyName_new');

      expect(copy.data, isNot(properties.data));
      expect(copy.attribution, isNot(properties.attribution));
      expect(copy.buffer, isNot(properties.buffer));
      expect(copy.tolerance, isNot(properties.tolerance));
      expect(copy.cluster, isNot(properties.cluster));
      expect(copy.clusterRadius, isNot(properties.clusterRadius));
      expect(copy.clusterMaxZoom, isNot(properties.clusterMaxZoom));
      expect(copy.promoteId, isNot(properties.promoteId));
    });

    test('copyWith returns a copy with unchanged values when not provided', () {
      GeojsonSourceProperties properties = GeojsonSourceProperties(
        data: {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [0, 0]
          }
        },
        maxzoom: 15,
        attribution: 'Map data © OpenStreetMap contributors',
        buffer: 256,
        tolerance: 0.5,
        cluster: true,
        clusterRadius: 50,
        clusterMaxZoom: 14,
        clusterProperties: {
          'sum': [
            '+',
            ['accumulated'],
            ['get', 'scalerank']
          ]
        },
        lineMetrics: true,
        generateId: true,
        promoteId: 'sourceLayer.propertyName',
      );

      final copy = properties.copyWith();

      // Check that the copy is equal to the original
      expect(copy.data, equals(properties.data));
    });
  });

  group('VideoSourceProperties', () {
    test('toJson should convert VideoSourceProperties to a map correctly', () {
      // Arrange
      VideoSourceProperties properties = VideoSourceProperties(
        urls: ['https://example.com/video1', 'https://example.com/video2'],
        coordinates: [
          [-90, -180],
          [90, 180]
        ],
      );

      // Act
      Map<String, dynamic> result = properties.toJson();

      // Assert
      expect(result['type'], equals('video'));
      expect(result['urls'],
          equals(['https://example.com/video1', 'https://example.com/video2']));
      expect(
          result['coordinates'],
          equals([
            [-90, -180],
            [90, 180]
          ]));
    });

    test('fromJson should convert a map to VideoSourceProperties correctly',
        () {
      // Arrange
      Map<String, dynamic> json = {
        'type': 'video',
        'urls': ['https://example.com/video1', 'https://example.com/video2'],
        'coordinates': [
          [-90, -180],
          [90, 180]
        ],
      };

      // Act
      VideoSourceProperties result = VideoSourceProperties.fromJson(json);

      // Assert
      expect(result.urls,
          equals(['https://example.com/video1', 'https://example.com/video2']));
      expect(
          result.coordinates,
          equals([
            [-90, -180],
            [90, 180]
          ]));
    });

    test('copyWith returns a copy with updated values', () {
      VideoSourceProperties properties = VideoSourceProperties(
        urls: ['https://example.com/video1', 'https://example.com/video2'],
        coordinates: [
          [-90, -180],
          [90, 180]
        ],
      );

      final copy = properties.copyWith(
        urls: ['https://example.com/video3', 'https://example.com/video4'],
        coordinates: [
          [-91, -181],
          [89, 179]
        ],
      );

      expect(copy.urls, isNot(properties.urls));
      expect(copy.coordinates, isNot(properties.coordinates));
    });

    test('copyWith returns a copy with unchanged values when not provided', () {
      VideoSourceProperties properties = VideoSourceProperties(
        urls: ['https://example.com/video1', 'https://example.com/video2'],
        coordinates: [
          [-90, -180],
          [90, 180]
        ],
      );

      final copy = properties.copyWith();

      expect(copy.coordinates, equals(properties.coordinates));
    });
  });

  group('ImageSourceProperties', () {
    test('toJson should convert ImageSourceProperties to a map correctly', () {
      // Arrange
      ImageSourceProperties properties = ImageSourceProperties(
        url: 'https://example.com/image',
        coordinates: [
          [-90, -180],
          [90, 180]
        ],
      );

      // Act
      Map<String, dynamic> result = properties.toJson();

      // Assert
      expect(result['type'], equals('image'));
      expect(result['url'], equals('https://example.com/image'));
      expect(
          result['coordinates'],
          equals([
            [-90, -180],
            [90, 180]
          ]));
    });

    test('fromJson should convert a map to ImageSourceProperties correctly',
        () {
      // Arrange
      Map<String, dynamic> json = {
        'type': 'image',
        'url': 'https://example.com/image',
        'coordinates': [
          [-90, -180],
          [90, 180]
        ],
      };

      // Act
      ImageSourceProperties result = ImageSourceProperties.fromJson(json);

      // Assert
      expect(result.url, equals('https://example.com/image'));
      expect(
          result.coordinates,
          equals([
            [-90, -180],
            [90, 180]
          ]));
    });

    test('copyWith returns a copy with updated values', () {
      ImageSourceProperties properties = ImageSourceProperties(
        url: 'https://example.com/image',
        coordinates: [
          [-90, -180],
          [90, 180]
        ],
      );

      final copy = properties.copyWith(
        url: "https://example.com/image_new",
        coordinates: [
          [-91, -181],
          [89, 179]
        ],
      );

      expect(copy.url, isNot(properties.url));
      expect(copy.coordinates, isNot(properties.coordinates));
    });

    test('copyWith returns a copy with unchanged values when not provided', () {
      ImageSourceProperties properties = ImageSourceProperties(
        url: 'https://example.com/image',
        coordinates: [
          [-90, -180],
          [90, 180]
        ],
      );

      final copy = properties.copyWith();

      expect(copy.coordinates, equals(properties.coordinates));
    });
  });
}
