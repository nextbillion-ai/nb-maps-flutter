import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

import 'global_test.mocks.dart';

//dart run build_runner build
@GenerateMocks([EventChannel, MethodChannel])
void main() {
  test('verify channel name', () {
    expect(globalChannel.name, equals('plugins.flutter.io/nb_maps_flutter'));
  });
  group('test gloabl.dart', () {
    MethodChannel mockChannel = MockMethodChannel();

    setUp(() {
      setTestingGlobalChannel(mockChannel);
    });

    test('installOfflineMapTiles test', () async {
      final tilesDb = 'path/to/tiles.db';
      when(mockChannel.invokeMethod('installOfflineMapTiles', any))
          .thenAnswer((_) async => null);
      await installOfflineMapTiles(tilesDb);
      verify(
          mockChannel.invokeMethod('installOfflineMapTiles', <String, dynamic>{
        'tilesdb': tilesDb,
      }));
    });

    test('setOffline test', () async {
      final offline = true;
      final accessToken = 'your_access_token';

      when(mockChannel.invokeMethod('setOffline', any))
          .thenAnswer((_) async => null);

      await setOffline(offline, accessToken: accessToken);

      final args = <String, dynamic>{
        'offline': offline,
        'accessToken': accessToken,
      };
      verify(mockChannel.invokeMethod('setOffline', args));
    });

    test('setHttpHeaders test', () async {
      final headers = {'Content-Type': 'application/json'};
      when(mockChannel.invokeMethod('setHttpHeaders', any))
          .thenAnswer((_) async => null);
      await setHttpHeaders(headers);
      Map<String, dynamic> args = <String, dynamic>{
        'headers': headers,
      };
      verify(mockChannel.invokeMethod('setHttpHeaders', args));
    });

    test('mergeOfflineRegions test', () async {
      final path = 'path/to/regions';
      final accessToken = 'your_access_token';
      Map<String, dynamic> args = <String, dynamic>{
        'path': path,
        'accessToken': accessToken,
      };

      String regionsJson = '''
        [
          {
            "id": 1,
            "definition": {
              "bounds": [
                [-10.0, -10.0],
                [10.0, 10.0]
              ],
              "mapStyleUrl": "mapstyle1",
              "minZoom": 1.0,
              "maxZoom": 2.0,
              "includeIdeographs": false
            },
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            }
          }
        ]
      ''';

      when(mockChannel.invokeMethod('mergeOfflineRegions', args))
          .thenAnswer((_) async => regionsJson);

      final regions = await mergeOfflineRegions(path, accessToken: accessToken);
      expect(regions.length, 1);
      expect(regions[0].id, 1);
      expect(regions[0].metadata, {'key1': 'value1', 'key2': 'value2'});
    });

    test('getListOfRegions test', () async {
      final accessToken = 'your_access_token';
      final args = <String, dynamic>{
        'accessToken': accessToken,
      };
      when(mockChannel.invokeMethod('getListOfRegions', args))
          .thenAnswer((_) async => '''
        [
          {
            "id": 1,
            "definition": {
              "bounds": [
                [-10.0, -10.0],
                [10.0, 10.0]
              ],
              "mapStyleUrl": "mapstyle1",
              "minZoom": 1.0,
              "maxZoom": 2.0,
              "includeIdeographs": false
            },
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            }
          }
        ]
      ''');
      final regions = await getListOfRegions(accessToken: accessToken);
      expect(regions.length, 1);
      expect(regions[0].id, 1);
      expect(regions[0].metadata, {'key1': 'value1', 'key2': 'value2'});
    });

    test('updateOfflineRegionMetadata test', () async {
      final id = 1;
      final metadata = {'name': 'Region 1'};
      final accessToken = 'your_access_token';
      final args = <String, dynamic>{
        'id': id,
        'accessToken': accessToken,
        'metadata': metadata,
      };

      when(mockChannel.invokeMethod('updateOfflineRegionMetadata', args))
          .thenAnswer((_) async => '''
        {
          "id": 1,
          "definition": {
            "bounds": [
              [-10.0, -10.0],
              [10.0, 10.0]
            ],
            "mapStyleUrl": "mapstyle1",
            "minZoom": 1.0,
            "maxZoom": 2.0,
            "includeIdeographs": false
          },
          "metadata": {
            "name": "Region 1"
          }
        }
      ''');
      final region = await updateOfflineRegionMetadata(id, metadata,
          accessToken: accessToken);

      expect(region.id, 1);
      expect(region.metadata, {"name": "Region 1"});
    });

    test('setOfflineTileCountLimit test', () async {
      final limit = 1000;
      final accessToken = 'your_access_token';
      final args = <String, dynamic>{
        'limit': limit,
        'accessToken': accessToken,
      };
      when(mockChannel.invokeMethod('setOfflineTileCountLimit', args))
          .thenAnswer((_) async => null);
      await setOfflineTileCountLimit(limit, accessToken: accessToken);
      verify(mockChannel.invokeMethod('setOfflineTileCountLimit', args));
    });

    test('deleteOfflineRegion test', () async {
      final id = 1;
      final accessToken = 'your_access_token';

      final args = <String, dynamic>{
        'id': id,
        'accessToken': accessToken,
      };

      when(mockChannel.invokeMethod('deleteOfflineRegion', args))
          .thenAnswer((_) async => null);

      await deleteOfflineRegion(id, accessToken: accessToken);
      verify(mockChannel.invokeMethod('deleteOfflineRegion', args));
    });

    test('downloadOfflineRegion test', () async {
      final definition = OfflineRegionDefinition(
        bounds: LatLngBounds(
          southwest: LatLng(37.5, -122.5),
          northeast: LatLng(37.9, -122.1),
        ),
        mapStyleUrl: 'https://example.com/style.json',
        minZoom: 10.0,
        maxZoom: 15.0,
      );
      final metadata = {'name': 'Region 1'};
      final accessToken = 'your_access_token';
      Function(DownloadRegionStatus event) onEvent = (event) => print(event);

      when(mockChannel.invokeMethod('downloadOfflineRegion', any))
          .thenAnswer((_) async => '''
          {
            "id": 1,
            "definition": {
              "bounds": [
                [-10.0, -10.0],
                [10.0, 10.0]
              ],
              "mapStyleUrl": "mapstyle1",
              "minZoom": 1.0,
              "maxZoom": 2.0,
              "includeIdeographs": false
            },
            "metadata": {
              "name": "Region 1"
            }
          }
        ''');
      WidgetsFlutterBinding.ensureInitialized();
      final region = await downloadOfflineRegion(
        definition,
        metadata: metadata,
        accessToken: accessToken,
        onEvent: onEvent,
      );

      expect(region.id, 1);
      expect(region.metadata, {"name": "Region 1"});
    });
  });

  test('downloadOfflineRegion with Error', () async {
    WidgetsFlutterBinding.ensureInitialized();

    final definition = OfflineRegionDefinition(
      bounds: LatLngBounds(
        southwest: LatLng(37.5, -122.5),
        northeast: LatLng(37.9, -122.1),
      ),
      mapStyleUrl: 'https://example.com/style.json',
      minZoom: 10.0,
      maxZoom: 15.0,
    );
    final metadata = {'name': 'Region 1'};
    final accessToken = 'your_access_token';

    final mockChannel = MockMethodChannel();
    setTestingGlobalChannel(mockChannel);

    // Arrange
    final mockEventChannel = MockEventChannel();
    final error = PlatformException(code: 'Error', message: 'Test error');

    EventChannelCreator eventChannelCreator = (channelName) {
      return mockEventChannel;
    };

    Stream stream = Stream.fromFuture(Future.error(error));
    when(mockEventChannel.receiveBroadcastStream()).thenAnswer((_) => stream);

    when(mockChannel.invokeMethod('downloadOfflineRegion', any))
        .thenAnswer((_) async => null);

    when(mockChannel.invokeMethod('downloadOfflineRegion', any))
        .thenAnswer((_) async => null);

    try {
      await downloadOfflineRegion(
        definition,
        metadata: metadata,
        accessToken: accessToken,
        onEvent: (event) {
          // Assert
          expect(event, isInstanceOf<Error>());
          // expect((event as Error).error, equals(error));
        },
        eventChannelCreator: eventChannelCreator,
      );
    } catch (e) {
      // This is expected to throw an error
    }

    verify(mockChannel.invokeMethod('downloadOfflineRegion', any)).called(1);
    verify(mockEventChannel.receiveBroadcastStream()).called(1);
  });
}
