import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:nb_maps_flutter_example/track_current_location.dart';
import 'package:permission_handler/permission_handler.dart';

import 'animate_camera.dart';
import 'annotation_order_maps.dart';
import 'click_annotations.dart';
import 'custom_marker.dart';
import 'full_map.dart';
import 'layer.dart';
import 'line.dart';
import 'local_style.dart';
import 'map_ui.dart';
import 'move_camera.dart';
import 'offline_regions.dart';
import 'page.dart';
import 'place_batch.dart';
import 'place_circle.dart';
import 'place_fill.dart';
import 'place_source.dart';
import 'place_symbol.dart';
import 'scrolling_map.dart';
import 'sources.dart';
import 'take_snapshot.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  MapUiPage(),
  FullMapPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  PlaceSymbolPage(),
  PlaceSourcePage(),
  LinePage(),
  LocalStylePage(),
  LayerPage(),
  PlaceCirclePage(),
  PlaceFillPage(),
  ScrollingMapPage(),
  OfflineRegionsPage(),
  AnnotationOrderPage(),
  CustomMarkerPage(),
  BatchAddPage(),
  TakeSnapPage(),
  ClickAnnotationPage(),
  Sources(),
  TrackCurrentLocationPage()
];

class MapsDemo extends StatefulWidget {
  static const String ACCESS_KEY = String.fromEnvironment("ACCESS_KEY");

  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  @override
  void initState() {
    super.initState();
    NextBillion.initNextBillion(MapsDemo.ACCESS_KEY);

    NextBillion.getUserId().then((value) {
      print("User id: $value");
    });
    NextBillion.setUserId("1234");
    NextBillion.getNbId().then((value) {
      print("NB id: $value");
    });

    NextBillion.getUserId().then((value) {
      print("User id: $value");
    });
  }

  /// Determine the android version of the phone and turn off HybridComposition
  /// on older sdk versions to improve performance for these
  ///
  /// !!! Hybrid composition is currently broken do no use !!!
  Future<void> initHybridComposition() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      if (sdkVersion != null && sdkVersion >= 29) {
        NBMap.useHybridComposition = true;
      } else {
        NBMap.useHybridComposition = false;
      }
    }
  }

  void _pushPage(BuildContext context, ExamplePage page) async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await [Permission.location].request();
    }

    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NbMaps examples')),
      body: MapsDemo.ACCESS_KEY.isEmpty ||
              MapsDemo.ACCESS_KEY.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (_, int index) => ListTile(
                leading: _allPages[index].leading,
                title: Text(_allPages[index].title),
                onTap: () => _pushPage(context, _allPages[index]),
              ),
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Using MapView requires calling Nextbillion.initNextbillion(String accessKey) "
                "before inflating or creating NBMap Widget. ",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsDemo()));
}
