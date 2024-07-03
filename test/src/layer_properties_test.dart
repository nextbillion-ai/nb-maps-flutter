import 'package:flutter_test/flutter_test.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

void main() {
  group('SymbolLayerProperties', () {
    test('SymbolLayerProperties toJson', () {
      final properties = SymbolLayerProperties(
        visibility: 'visible',
      );

      final json = properties.toJson();

      expect(json['visibility'], 'visible');
    });

    test('SymbolLayerProperties fromJson', () {
      final json = {
        'visibility': 'visible',
      };

      final properties = SymbolLayerProperties.fromJson(json);

      expect(properties.visibility, 'visible');
    });

    test('SymbolLayerProperties copyWith', () {
      SymbolLayerProperties properties = SymbolLayerProperties(
        visibility: 'visible',
      );
      expect(properties.visibility, 'visible');

      final json = {
        'visibility': 'none',
      };

      final newProperties = SymbolLayerProperties.fromJson(json);
      properties = properties.copyWith(newProperties);
      expect(properties.visibility, 'none');
    });
  });
  group('CircleLayerProperties', () {
    test('CircleLayerProperties toJson', () {
      final properties = CircleLayerProperties(
        visibility: 'visible',
      );

      final json = properties.toJson();

      expect(json['visibility'], 'visible');
    });

    test('CircleLayerProperties fromJson', () {
      final json = {
        'visibility': 'visible',
      };

      final properties = CircleLayerProperties.fromJson(json);

      expect(properties.visibility, 'visible');
    });

    test('CircleLayerProperties copyWith', () {
      CircleLayerProperties properties = CircleLayerProperties(
        visibility: 'visible',
      );
      expect(properties.visibility, 'visible');

      final json = {
        'visibility': 'none',
      };

      final newProperties = CircleLayerProperties.fromJson(json);
      properties = properties.copyWith(newProperties);
      expect(properties.visibility, 'none');
    });
  });
  group('FillLayerProperties', () {
    test('FillLayerProperties toJson', () {
      final properties = FillLayerProperties(
        visibility: 'visible',
      );

      final json = properties.toJson();

      expect(json['visibility'], 'visible');
    });

    test('FillLayerProperties fromJson', () {
      final json = {
        'visibility': 'visible',
      };

      final properties = FillLayerProperties.fromJson(json);

      expect(properties.visibility, 'visible');
    });

    test('FillLayerProperties copyWith', () {
      FillLayerProperties properties = FillLayerProperties(
        visibility: 'visible',
      );
      expect(properties.visibility, 'visible');

      final json = {
        'visibility': 'none',
      };

      final newProperties = FillLayerProperties.fromJson(json);
      properties = properties.copyWith(newProperties);
      expect(properties.visibility, 'none');
    });
  });
  group('LineLayerProperties', () {
    test('LineLayerProperties toJson', () {
      final properties = LineLayerProperties(
        visibility: 'visible',
      );

      final json = properties.toJson();

      expect(json['visibility'], 'visible');
    });

    test('LineLayerProperties fromJson', () {
      final json = {
        'visibility': 'visible',
      };

      final properties = LineLayerProperties.fromJson(json);

      expect(properties.visibility, 'visible');
    });

    test('LineLayerProperties copyWith', () {
      LineLayerProperties properties = LineLayerProperties(
        visibility: 'visible',
      );
      expect(properties.visibility, 'visible');

      final json = {
        'visibility': 'none',
      };

      final newProperties = LineLayerProperties.fromJson(json);
      properties = properties.copyWith(newProperties);
      expect(properties.visibility, 'none');
    });
  });
  group('RasterLayerProperties', () {
    test('RasterLayerProperties toJson', () {
      final properties = RasterLayerProperties(
        visibility: 'visible',
      );

      final json = properties.toJson();

      expect(json['visibility'], 'visible');
    });

    test('RasterLayerProperties fromJson', () {
      final json = {
        'visibility': 'visible',
      };

      final properties = RasterLayerProperties.fromJson(json);

      expect(properties.visibility, 'visible');
    });

    test('RasterLayerProperties copyWith', () {
      RasterLayerProperties properties = RasterLayerProperties(
        visibility: 'visible',
      );
      expect(properties.visibility, 'visible');

      final json = {
        'visibility': 'none',
      };

      final newProperties = RasterLayerProperties.fromJson(json);
      properties = properties.copyWith(newProperties);
      expect(properties.visibility, 'none');
    });
  });
}
