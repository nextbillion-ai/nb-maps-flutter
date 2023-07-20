# Nextbillion Maps Flutter

## Instroduction
![WechatIMG435](https://github.com/nextbillion-ai/nb-maps-flutter/assets/100656364/f6f59804-d96d-46f8-b324-c383b8f55740)


## Prerequisites
* Access Key
* Android minSdkVersion 16+
* iOS 11+
* Flutter 3.10+
* Pod 1.11.3+

## Installation
### Dependency
Add the following dependency to your project pubspec.yaml file to use the NB Maps Flutter Plugin add the dependency to the pubspec.yaml:
```
dependencies:
  nb_maps_flutter: version
```

### Import
Import the maps plugin in your code
```
import 'package:nb_maps_flutter/nb_maps_flutter.dart';
```

### Initialization
To run the Maps Flutter Plugin you will need to configure the NB Maps Token at the beginning of your flutter app using `NextBillion.initNextBillion(YOUR_ACCESS_KEY)`. 
```
 class _MapsDemoState extends State<MapsDemo> {
  @override
  void initState() {
    super.initState();
    NextBillion.initNextBillion(YOUR_ACCESS_KEY);
  }
}
```

## NBMap Widget
Create a NBMap Widget with initial camera position
```
NBMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: const CameraPosition(
           target: LatLng(0.0, 0.0),
           zoom: 11.0,
  ),
)
```
## Location Component
### Configuration permissions
You need to grant location permission in order to use the location component of the NB Maps Flutter Plugin, declare the permission for both platforms:
### Android
Add the following permissions to the manifest:
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS
Add the following to the Runner/Info.plist to explain why you need access to the location data:
```
 <key>NSLocationWhenInUseUsageDescription</key>
    <string>[Your explanation here]</string>
```

### Enable Location Tracking
* trackCameraPosition: true
* myLocationEnabled: true
* myLocationTrackingMode: MyLocationTrackingMode.Tracking

### Observe User Location Updating
* add the callback onUserLocationUpdated(UserLocation location)
```
NBMap(
     onMapCreated: _onMapCreated,
     initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 14.0,
          ),
     trackCameraPosition: true,
     myLocationEnabled: true,
     myLocationTrackingMode: MyLocationTrackingMode.Tracking,
     onUserLocationUpdated: (userLocation) {},
)
```

## Annotations
To operate the mapview, you need to get the map controller in the `onMapReady(NextbillionMapController controller) callback`.
### Symbol Annotation
The Symbol annotation adds a symbol to the map. It is configured by the specified custom SymbolOptions. If you need to add an image symbol, you need to add the image source to the map style.
#### Add image source
```
final ByteData bytes = await rootBundle.load("assets/image.png");
final Uint8List list = bytes.buffer.asUint8List();
await controller?.addImage("ic_marker", list);
```
```
var symbol = controller.addSymbol(
      SymbolOptions(
          geometry: LatLng(-33.894372606072309, 151.17576679759523),
          iconImage: "ic_marker",
          iconSize: 2),
    );

//remove annotation
controller!.removeSymbol(symbol);

//update annotation
controller!.updateSymbol(symbol, updatedOptions)
```
#### Line Annotation
The Line annotation adds a line to the map. It is configured by the specified custom LineOptions.
```
var line = controller.addLine(
      LineOptions(
        geometry: [
          LatLng(-33.874867744475786, 151.170627211986584),
          LatLng(-33.881979408447314, 151.171361438502117),
          LatLng(-33.887058805548882, 151.175032571079726),
        ],
        lineColor: "#0000FF",
        lineWidth: 20,
      ),
    );

//remove annotation
controller!.removeLine(line);

//update annotation
controller!.updateLine(line, updatedOptions)
```
#### Fill Annotation
The Fill annotation adds a fill to the map. It is configured using the specified custom FillOptions.
```
var fill = controller!.addFill(
      FillOptions(
        geometry: [
          [
            LatLng(-33.901517742631846, 151.178099204457737),
            LatLng(-33.872845324482071, 151.179025547977773),
            LatLng(-33.868230472039514, 151.147000529140399),
            LatLng(-33.883172899638311, 151.150838238009328),
            LatLng(-33.901517742631846, 151.178099204457737),
          ],
        ],
        fillColor: "#FF0000",
        fillOutlineColor: "#000000",
      ),
    )

//remove annotation
controller!.removeFill(fill);

//update annotation
controller!.updateFill(fill, updatedOptions)
```
#### Circle Annotation
The Circle annotation adds a circle to the map. It is configured using the specified custom CircleOptions.
```
var addCircle = controller!.addCircle(
      CircleOptions(
        geometry: LatLng(-33.894372606072309, 151.17576679759523),
        circleStrokeColor: "#00FF00",
        circleStrokeWidth: 2,
        circleRadius: 30,
      ),
    );
```
#### Annotation onTap Callbacks
The following code snippet shows how to add Callbacks to receive tap events, and how to place annotations on this map, and how to remove these callbacks in dispose() function.
```
void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
    controller.onFillTapped.add(_onFillTapped);
    controller.onCircleTapped.add(_onCircleTapped);
    controller.onLineTapped.add(_onLineTapped);
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

 @override
  void dispose() {
    controller.onFillTapped.remove(_onFillTapped);
    controller.onCircleTapped.remove(_onCircleTapped);
    controller.onLineTapped.remove(_onLineTapped);
    controller.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }
```

## Camera
Defines a camera move, supports absolute moves as well as moving relatively to a specified position.
### CameraUpdate
A Camera update moves the camera to the specified CameraPosition with the camera's [target] geographical location, its [zoom] level, [tilt] angle and [bearing].
```
CameraUpdate.newCameraPosition(
       const CameraPosition(
              bearing: 270.0,
              target: LatLng(51.5160895, -0.1294527),
              tilt: 30.0,
              zoom: 17.0,
        ),
 )
controller.animateCamera(cameraUpdate)
```
The following code snippet shows how to move the camera target to a specified geographical location.
```
CameraUpdate.newLatLng(const LatLng(56.1725505, 10.1850512))
```
### Move Camera
The animateCamera() function starts an animated change of the map camera position
```
controller.animateCamera(cameraUpdate, duration)
```
The moveCamera function will move the camera quickly, which can be visually jarring for a user. In real usage we should strongly consider using the animateCamera() methods instead of moveCamera() because it's less abrupt.
```
controller.moveCamera(cameraUpdate)
```
### More
* scrollBy()
* zoomBy()
* zoomIn()
* zoomOut()
* zoomTo(double zoom)
* bearingTo(double bearing)
* tiltTo(double tilt)
