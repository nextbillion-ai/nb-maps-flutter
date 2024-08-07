import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_maps_flutter/nb_maps_flutter.dart';

import 'page.dart';

class PlaceSourcePage extends ExamplePage {
  PlaceSourcePage() : super(const Icon(Icons.place), 'Place source');

  @override
  Widget build(BuildContext context) {
    return const PlaceSymbolBody();
  }
}

class PlaceSymbolBody extends StatefulWidget {
  const PlaceSymbolBody();

  @override
  State<StatefulWidget> createState() => PlaceSymbolBodyState();
}

class PlaceSymbolBodyState extends State<PlaceSymbolBody> {
  PlaceSymbolBodyState();

  static const SOURCE_ID = 'sydney_source';
  static const LAYER_ID = 'sydney_layer';

  bool sourceAdded = false;
  bool layerAdded = false;
  late NextbillionMapController controller;

  void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Adds an asset image as a source to the currently displayed style
  Future<void> addImageSourceFromAsset(
      String imageSourceId, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImageSource(
      imageSourceId,
      list,
      const LatLngQuad(
        bottomRight: LatLng(-33.86264728692581, 151.19916915893555),
        bottomLeft: LatLng(-33.86264728692581, 151.2288236618042),
        topLeft: LatLng(-33.84322353475214, 151.2288236618042),
        topRight: LatLng(-33.84322353475214, 151.19916915893555),
      ),
    );
  }

  /// Update an asset image as a source to the currently displayed style
  Future<void> updateImageSourceFromAsset(
      String imageSourceId, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.updateImageSource(
      imageSourceId,
      list,
      const LatLngQuad(
        bottomRight: LatLng(-33.89884564291081, 151.25229835510254),
        bottomLeft: LatLng(-33.89884564291081, 151.20131492614746),
        topLeft: LatLng(-33.934601369931634, 151.20131492614746),
        topRight: LatLng(-33.934601369931634, 151.25229835510254),
      ),
    );
  }

  Future<void> removeImageSource(String imageSourceId) {
    return controller.removeSource(imageSourceId);
  }

  Future<void> addLayer(String imageLayerId, String imageSourceId) {
    if (layerAdded) {
      removeLayer(imageLayerId);
    }
    setState(() => layerAdded = true);
    return controller.addImageLayer(imageLayerId, imageSourceId);
  }

  Future<void> addLayerBelow(
      String imageLayerId, String imageSourceId, String belowLayerId) {
    if (layerAdded) {
      removeLayer(imageLayerId);
    }
    setState(() => layerAdded = true);
    return controller.addImageLayerBelow(
        imageLayerId, imageSourceId, belowLayerId);
  }

  Future<void> removeLayer(String imageLayerId) {
    setState(() => layerAdded = false);
    return controller.removeLayer(imageLayerId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 300.0,
          child: NBMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-33.852, 151.211),
              zoom: 10.0,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextButton(
                      child: const Text('Add source (asset image)'),
                      onPressed: sourceAdded
                          ? null
                          : () {
                              addImageSourceFromAsset(SOURCE_ID,
                                      'assets/symbols/custom-icon.png')
                                  .then((value) {
                                setState(() => sourceAdded = true);
                              });
                            },
                    ),
                    TextButton(
                      child: const Text('Update source (asset image)'),
                      onPressed: !sourceAdded
                          ? null
                          : () {
                              updateImageSourceFromAsset(SOURCE_ID,
                                      'assets/symbols/custom-icon.png')
                                  .then((value) {
                                setState(() => sourceAdded = true);
                              });
                            },
                    ),
                    TextButton(
                      child: const Text('Remove source (asset image)'),
                      onPressed: sourceAdded
                          ? () async {
                              await removeLayer(LAYER_ID);
                              removeImageSource(SOURCE_ID).then((value) {
                                setState(() => sourceAdded = false);
                              });
                            }
                          : null,
                    ),
                    TextButton(
                      child: const Text('Show layer'),
                      onPressed: sourceAdded
                          ? () => addLayer(LAYER_ID, SOURCE_ID)
                          : null,
                    ),
                    TextButton(
                      child: const Text('Show layer below water'),
                      onPressed: sourceAdded
                          ? () => addLayerBelow(LAYER_ID, SOURCE_ID, 'water')
                          : null,
                    ),
                    TextButton(
                      child: const Text('Hide layer'),
                      onPressed:
                          sourceAdded ? () => removeLayer(LAYER_ID) : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
