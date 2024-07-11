import 'package:flutter/material.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

import 'page.dart';

class TrackCurrentLocationPage extends ExamplePage {
  TrackCurrentLocationPage()
      : super(const Icon(Icons.place), 'TrackCurrentLocation');

  @override
  Widget build(BuildContext context) {
    return TrackCurrentLocation();
  }
}

class TrackCurrentLocation extends StatefulWidget {
  @override
  TrackCurrentLocationState createState() => TrackCurrentLocationState();
}

class TrackCurrentLocationState extends State<TrackCurrentLocation> {
  NextbillionMapController? controller;

  String locationTrackImage = "assets/symbols/location_on.png";

  void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    controller?.updateMyLocationTrackingMode(MyLocationTrackingMode.Tracking);
  }

  _onUserLocationUpdate(UserLocation location) {
    print('${location.position.longitude}, ${location.position.latitude}');
  }

  _onCameraTrackingChanged() {
    setState(() {
      locationTrackImage = 'assets/symbols/location_off.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NBMap(
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 14.0,
            ),
            trackCameraPosition: true,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
            onUserLocationUpdated: _onUserLocationUpdate,
            onCameraTrackingDismissed: _onCameraTrackingChanged,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 100),
                child: GestureDetector(
                    child: Image(
                      image: AssetImage(locationTrackImage),
                      width: 28,
                      height: 28,
                    ),
                    onTap: () {
                      controller?.updateMyLocationTrackingMode(
                          MyLocationTrackingMode.Tracking);
                      setState(() {
                        locationTrackImage = 'assets/symbols/location_on.png';
                      });
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
