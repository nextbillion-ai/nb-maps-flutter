import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

import 'nextbillion_test.mocks.dart';

//dart run build_runner build
@GenerateMocks([MethodChannel])
void main() {
  test('verify default method channel name', () {
    expect(NextBillion().channel.name,
        equals("plugins.flutter.io/nextbillion_init"));
  });

  group('mock method channel', () {
    late MethodChannel channel;

    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      channel = MockMethodChannel();
      NextBillion.setMockMethodChannel(channel);

      // 1 nextbillion/init_nextbillion
      // 2 nextbillion/get_access_key
      // 3 nextbillion/set_access_key
      // 4 nextbillion/get_base_uri
      // 5 nextbillion/set_base_uri
      // 6 nextbillion/set_key_header_name
      // 7 nextbillion/get_key_header_name
      // 8 nextbillion/get_nb_id
      // 9 nextbillion/set_user_id
      // 10 nextbillion/get_user_id
    });

    // 1 nextbillion/init_nextbillion
    test('NextBillion should initialize correctly', () async {
      when(channel.invokeMethod(
              'nextbillion/init_nextbillion', {'accessKey': 'accessKey'}))
          .thenAnswer((_) async => null);

      await NextBillion.initNextBillion('accessKey');
      verify(channel.invokeMethod(
          'nextbillion/init_nextbillion', {'accessKey': 'accessKey'}));
    });

    // 2 nextbillion/get_access_key
    test('NextBillion should get access key correctly', () async {
      const String expectedAccessKey = 'asscessKey';

      when(channel.invokeMethod('nextbillion/get_access_key'))
          .thenAnswer((_) async => expectedAccessKey);

      String accessKey = await NextBillion.getAccessKey();
      expect(accessKey, equals(expectedAccessKey));
    });

    // 3 nextbillion/set_access_key
    test('NextBillion should set access key correctly', () async {
      Map<String, dynamic> arguments = {"accessKey": 'accessKey'};
      when(channel.invokeMethod('nextbillion/set_access_key', arguments))
          .thenAnswer((_) async => null);

      await NextBillion.setAccessKey('accessKey');
      verify(channel.invokeMethod('nextbillion/set_access_key', arguments));
    });

    // 4 nextbillion/get_base_uri
    test('NextBillion should get base URI correctly', () async {
      const String expectedBaseUri = 'baseUri';

      when(channel.invokeMethod('nextbillion/get_base_uri'))
          .thenAnswer((_) async => expectedBaseUri);

      String baseUri = await NextBillion.getBaseUri();
      expect(baseUri, equals(expectedBaseUri));
    });

    // 5 nextbillion/set_base_uri
    test('NextBillion should set base URI correctly', () async {
      Map<String, dynamic> arguments = {"baseUri": 'baseUri'};
      when(channel.invokeMethod('nextbillion/set_base_uri', arguments))
          .thenAnswer((_) async => null);

      await NextBillion.setBaseUri('baseUri');
      verify(channel.invokeMethod('nextbillion/set_base_uri', arguments));
    });

    // 6 nextbillion/set_key_header_name
    test('NextBillion should set API key header name correctly', () async {
      Map<String, dynamic> arguments = {"apiKeyHeaderName": 'apiKeyHeaderName'};
      when(channel.invokeMethod('nextbillion/set_key_header_name', arguments))
          .thenAnswer((_) async => null);

      await NextBillion.setApiKeyHeaderName('apiKeyHeaderName');

      verify(
          channel.invokeMethod('nextbillion/set_key_header_name', arguments));
    });

    // 7 nextbillion/get_key_header_name
    test('NextBillion should get API key header name correctly', () async {
      const String expectedHeaderName = 'headerName';

      when(channel.invokeMethod('nextbillion/get_key_header_name'))
          .thenAnswer((_) async => expectedHeaderName);

      String apiKeyHeaderName = await NextBillion.getApiKeyHeaderName();
      expect(apiKeyHeaderName, expectedHeaderName);
    });

    // 8 nextbillion/get_nb_id
    test('NextBillion should get NB ID correctly', () async {
      const String expectedNBID = 'nbid';

      when(channel.invokeMethod('nextbillion/get_nb_id'))
          .thenAnswer((_) async => expectedNBID);

      String nbId = await NextBillion.getNbId();
      expect(nbId, expectedNBID);
    });

    // 9 nextbillion/set_user_id
    test('NextBillion should set user ID correctly', () async {
      Map<String, dynamic> arguments = {"userId": 'userId'};
      when(channel.invokeMethod('nextbillion/set_user_id', arguments))
          .thenAnswer((_) async => null);

      await NextBillion.setUserId('userId');
      verify(channel.invokeMethod('nextbillion/set_user_id', arguments));
    });

    // 10 nextbillion/get_user_id
    test('NextBillion should get user ID correctly', () async {
      const String expectedUserId = 'userId';

      when(channel.invokeMethod('nextbillion/get_user_id'))
          .thenAnswer((_) async => expectedUserId);

      String? userId = await NextBillion.getUserId();
      expect(userId, expectedUserId);
    });
  });
}
