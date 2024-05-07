part of nb_maps_flutter;

typedef void OnMapClickCallback(Point<double> point, LatLng coordinates);

typedef void OnFeatureInteractionCallback(dynamic id, Point<double> point, LatLng coordinates);

typedef void OnFeatureDragnCallback(dynamic id,
    {required Point<double> point,
    required LatLng origin,
    required LatLng current,
    required LatLng delta,
    required DragEventType eventType});

typedef void OnMapLongClickCallback(Point<double> point, LatLng coordinates);

typedef void OnAttributionClickCallback();

typedef void OnStyleLoadedCallback();

typedef void OnUserLocationUpdated(UserLocation location);

typedef void OnCameraTrackingDismissedCallback();
typedef void OnCameraTrackingChangedCallback(MyLocationTrackingMode mode);

typedef void OnCameraIdleCallback();

typedef void OnMapIdleCallback();

/// Controller for a single NBMap instance running on the host platform.
///
/// Change listeners are notified upon changes to any of
///
/// * the [options] property
/// * the collection of [Symbol]s added to this map
/// * the collection of [Line]s added to this map
/// * the [isCameraMoving] property
/// * the [cameraPosition] property
///
/// Listeners are notified after changes have been applied on the platform side.
///
/// Symbol tap events can be received by adding callbacks to [onSymbolTapped].
/// Line tap events can be received by adding callbacks to [onLineTapped].
/// Circle tap events can be received by adding callbacks to [onCircleTapped].
class NextbillionMapController extends ChangeNotifier {
  NextbillionMapController({
    required NbMapsGlPlatform nbMapsGlPlatform,
    required CameraPosition initialCameraPosition,
    required Iterable<AnnotationType> annotationOrder,
    required Iterable<AnnotationType> annotationConsumeTapEvents,
    this.onStyleLoadedCallback,
    this.onMapClick,
    this.onMapLongClick,
    this.onAttributionClick,
    this.onCameraTrackingDismissed,
    this.onCameraTrackingChanged,
    this.onMapIdle,
    this.onUserLocationUpdated,
    this.onCameraIdle,
  }) : _nbMapsGlPlatform = nbMapsGlPlatform {
    _cameraPosition = initialCameraPosition;

    _nbMapsGlPlatform.onFeatureTappedPlatform.add((payload) {
      for (final fun in List<OnFeatureInteractionCallback>.from(onFeatureTapped)) {
        fun(payload["id"], payload["point"], payload["latLng"]);
      }
    });

    _nbMapsGlPlatform.onFeatureDraggedPlatform.add((payload) {
      for (final fun in List<OnFeatureDragnCallback>.from(onFeatureDrag)) {
        final DragEventType enmDragEventType =
            DragEventType.values.firstWhere((element) => element.index == payload["eventType"]);
        fun(payload["id"],
            point: payload["point"],
            origin: payload["origin"],
            current: payload["current"],
            delta: payload["delta"],
            eventType: enmDragEventType);
      }
    });

    _nbMapsGlPlatform.onCameraMoveStartedPlatform.add((_) {
      _isCameraMoving = true;
      notifyListeners();
    });

    _nbMapsGlPlatform.onCameraMovePlatform.add((cameraPosition) {
      _cameraPosition = cameraPosition;
      notifyListeners();
    });

    _nbMapsGlPlatform.onCameraIdlePlatform.add((cameraPosition) {
      _isCameraMoving = false;
      if (cameraPosition != null) {
        _cameraPosition = cameraPosition;
      }
      if (onCameraIdle != null) {
        onCameraIdle!();
      }
      notifyListeners();
    });

    _nbMapsGlPlatform.onMapStyleLoadedPlatform.add((_) {
      final interactionEnabled = annotationConsumeTapEvents.toSet();
      for (var type in annotationOrder.toSet()) {
        final enableInteraction = interactionEnabled.contains(type);
        switch (type) {
          case AnnotationType.fill:
            fillManager = FillManager(this, onTap: onFillTapped, enableInteraction: enableInteraction);
            break;
          case AnnotationType.line:
            lineManager = LineManager(this, onTap: onLineTapped, enableInteraction: enableInteraction);
            break;
          case AnnotationType.circle:
            circleManager = CircleManager(this, onTap: onCircleTapped, enableInteraction: enableInteraction);
            break;
          case AnnotationType.symbol:
            symbolManager = SymbolManager(this, onTap: onSymbolTapped, enableInteraction: enableInteraction);
            break;
          default:
        }
      }
      if (onStyleLoadedCallback != null) {
        onStyleLoadedCallback!();
      }
    });

    _nbMapsGlPlatform.onMapClickPlatform.add((dict) {
      if (onMapClick != null) {
        onMapClick!(dict['point'], dict['latLng']);
      }
    });

    _nbMapsGlPlatform.onMapLongClickPlatform.add((dict) {
      if (onMapLongClick != null) {
        onMapLongClick!(dict['point'], dict['latLng']);
      }
    });

    _nbMapsGlPlatform.onAttributionClickPlatform.add((_) {
      if (onAttributionClick != null) {
        onAttributionClick!();
      }
    });

    _nbMapsGlPlatform.onCameraTrackingChangedPlatform.add((mode) {
      if (onCameraTrackingChanged != null) {
        onCameraTrackingChanged!(mode);
      }
    });

    _nbMapsGlPlatform.onCameraTrackingDismissedPlatform.add((_) {
      if (onCameraTrackingDismissed != null) {
        onCameraTrackingDismissed!();
      }
    });

    _nbMapsGlPlatform.onMapIdlePlatform.add((_) {
      if (onMapIdle != null) {
        onMapIdle!();
      }
    });
    _nbMapsGlPlatform.onUserLocationUpdatedPlatform.add((location) {
      onUserLocationUpdated?.call(location);
    });
  }

  bool _disposed = false;

  FillManager? fillManager;
  LineManager? lineManager;
  CircleManager? circleManager;
  SymbolManager? symbolManager;

  final OnStyleLoadedCallback? onStyleLoadedCallback;
  final OnMapClickCallback? onMapClick;
  final OnMapLongClickCallback? onMapLongClick;

  final OnUserLocationUpdated? onUserLocationUpdated;
  final OnAttributionClickCallback? onAttributionClick;

  final OnCameraTrackingDismissedCallback? onCameraTrackingDismissed;
  final OnCameraTrackingChangedCallback? onCameraTrackingChanged;

  final OnCameraIdleCallback? onCameraIdle;

  final OnMapIdleCallback? onMapIdle;

  /// Callbacks to receive tap events for symbols placed on this map.
  final ArgumentCallbacks<Symbol> onSymbolTapped = ArgumentCallbacks<Symbol>();

  /// Callbacks to receive tap events for symbols placed on this map.
  final ArgumentCallbacks<Circle> onCircleTapped = ArgumentCallbacks<Circle>();

  /// Callbacks to receive tap events for fills placed on this map.
  final ArgumentCallbacks<Fill> onFillTapped = ArgumentCallbacks<Fill>();

  /// Callbacks to receive tap events for features (geojson layer) placed on this map.
  final onFeatureTapped = <OnFeatureInteractionCallback>[];

  final onFeatureDrag = <OnFeatureDragnCallback>[];

  /// Callbacks to receive tap events for info windows on symbols
  @Deprecated("InfoWindow tapped is no longer supported")
  final ArgumentCallbacks<Symbol> onInfoWindowTapped = ArgumentCallbacks<Symbol>();

  /// The current set of symbols on this map.
  ///
  /// The returned set will be a detached snapshot of the symbols collection.
  Set<Symbol> get symbols => symbolManager!.annotations;

  /// Callbacks to receive tap events for lines placed on this map.
  final ArgumentCallbacks<Line> onLineTapped = ArgumentCallbacks<Line>();

  /// The current set of lines on this map.
  ///
  /// The returned set will be a detached snapshot of the lines collection.
  Set<Line> get lines => lineManager!.annotations;

  /// The current set of circles on this map.
  ///
  /// The returned set will be a detached snapshot of the circles collection.
  Set<Circle> get circles => circleManager!.annotations;

  /// The current set of fills on this map.
  ///
  /// The returned set will be a detached snapshot of the fills collection.
  Set<Fill> get fills => fillManager!.annotations;

  /// True if the map camera is currently moving.
  bool get isCameraMoving => _isCameraMoving;
  bool _isCameraMoving = false;

  /// Returns the most recent camera position reported by the platform side.
  /// Will be null, if [NBMap.trackCameraPosition] is false.
  CameraPosition? get cameraPosition => _cameraPosition;
  CameraPosition? _cameraPosition;

  final NbMapsGlPlatform _nbMapsGlPlatform; //ignore: unused_field

  /// Updates configuration options of the map user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) async {
    _disposeGuard();
    _cameraPosition = await _nbMapsGlPlatform.updateMapOptions(optionsUpdate);
    notifyListeners();
  }

  /// Triggers a resize event for the map on web (ignored on Android or iOS).
  ///
  /// Checks first if a resize is required or if it looks like it is already correctly resized.
  /// If it looks good, the resize call will be skipped.
  ///
  /// To force resize map (without any checks) have a look at forceResizeWebMap()
  void resizeWebMap() {
    _disposeGuard();
    _nbMapsGlPlatform.resizeWebMap();
  }

  /// Triggers a hard map resize event on web and does not check if it is required or not.
  void forceResizeWebMap() {
    _disposeGuard();
    _nbMapsGlPlatform.forceResizeWebMap();
  }

  /// Starts an animated change of the map camera position.
  ///
  /// [duration] is the amount of time, that the transition animation should take.
  ///
  /// The returned [Future] completes after the change has been started on the
  /// platform side.
  /// It returns true if the camera was successfully moved and false if the movement was canceled.
  /// Note: this currently always returns immediately with a value of null on iOS
  Future<bool?> animateCamera(CameraUpdate cameraUpdate, {Duration? duration}) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.animateCamera(cameraUpdate, duration: duration);
  }

  /// Instantaneously re-position the camera.
  /// Note: moveCamera() quickly moves the camera, which can be visually jarring for a user. Strongly consider using the animateCamera() methods instead because it's less abrupt.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  /// It returns true if the camera was successfully moved and false if the movement was canceled.
  /// Note: this currently always returns immediately with a value of null on iOS
  Future<bool?> moveCamera(CameraUpdate cameraUpdate) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.moveCamera(cameraUpdate);
  }

  /// Adds a new geojson source
  ///
  /// The json in [geojson] has to comply with the schema for FeatureCollection
  /// as specified in https://datatracker.ietf.org/doc/html/rfc7946#section-3.3
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  Future<void> addGeoJsonSource(String sourceId, Map<String, dynamic> geojson, {String? promoteId}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addGeoJsonSource(sourceId, geojson, promoteId: promoteId);
  }

  /// Sets new geojson data to and existing source
  ///
  /// This only works as exected if the source has been created with
  /// [addGeoJsonSource] before. This is very useful if you want to update and
  /// existing source with modified data.
  ///
  /// The json in [geojson] has to comply with the schema for FeatureCollection
  /// as specified in https://datatracker.ietf.org/doc/html/rfc7946#section-3.3
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> setGeoJsonSource(String sourceId, Map<String, dynamic> geojson) async {
    _disposeGuard();
    await _nbMapsGlPlatform.setGeoJsonSource(sourceId, geojson);
  }

  /// Sets new geojson data to and existing source
  ///
  /// This only works as exected if the source has been created with
  /// [addGeoJsonSource] before. This is very useful if you want to update and
  /// existing source with modified data.
  ///
  /// The json in [geojson] has to comply with the schema for FeatureCollection
  /// as specified in https://datatracker.ietf.org/doc/html/rfc7946#section-3.3
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> setGeoJsonFeature(String sourceId, Map<String, dynamic> geojsonFeature) async {
    _disposeGuard();
    await _nbMapsGlPlatform.setFeatureForGeoJsonSource(sourceId, geojsonFeature);
  }

  /// Add a symbol layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// If [enableInteraction] is set the layer is considered for touch or drag
  /// events. [sourceLayer] is used to selected a specific source layer from
  /// Vector source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  /// [filter] determines which features should be rendered in the layer.
  /// Filters are written as [expressions].
  ///
  Future<void> addSymbolLayer(String sourceId, String layerId, SymbolLayerProperties properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      bool enableInteraction = true}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addSymbolLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
      enableInteraction: enableInteraction,
    );
  }

  /// Add a line layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// If [enableInteraction] is set the layer is considered for touch or drag
  /// events. [sourceLayer] is used to selected a specific source layer from
  /// Vector source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  /// [filter] determines which features should be rendered in the layer.
  /// Filters are written as [expressions].
  ///
  Future<void> addLineLayer(String sourceId, String layerId, LineLayerProperties properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      bool enableInteraction = true}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addLineLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
      enableInteraction: enableInteraction,
    );
  }

  /// Add a fill layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// If [enableInteraction] is set the layer is considered for touch or drag
  /// events. [sourceLayer] is used to selected a specific source layer from
  /// Vector source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  /// [filter] determines which features should be rendered in the layer.
  /// Filters are written as [expressions].
  ///
  Future<void> addFillLayer(String sourceId, String layerId, FillLayerProperties properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      bool enableInteraction = true}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addFillLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
      enableInteraction: enableInteraction,
    );
  }

  /// Add a fill extrusion layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// If [enableInteraction] is set the layer is considered for touch or drag
  /// events. [sourceLayer] is used to selected a specific source layer from
  /// Vector source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  /// [filter] determines which features should be rendered in the layer.
  /// Filters are written as [expressions].
  ///
  Future<void> addFillExtrusionLayer(String sourceId, String layerId, FillExtrusionLayerProperties properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      bool enableInteraction = true}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addFillExtrusionLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
      enableInteraction: enableInteraction,
    );
  }

  /// Add a circle layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// If [enableInteraction] is set the layer is considered for touch or drag
  /// events. [sourceLayer] is used to selected a specific source layer from
  /// Vector source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  /// [filter] determines which features should be rendered in the layer.
  /// Filters are written as [expressions].
  ///
  Future<void> addCircleLayer(String sourceId, String layerId, CircleLayerProperties properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      bool enableInteraction = true}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addCircleLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
      enableInteraction: enableInteraction,
    );
  }

  /// Add a raster layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// [sourceLayer] is used to selected a specific source layer from
  /// Raster source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  Future<void> addRasterLayer(String sourceId, String layerId, RasterLayerProperties properties,
      {String? belowLayerId, String? sourceLayer, double? minzoom, double? maxzoom}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addRasterLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
    );
  }

  /// Add a hillshade layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// [sourceLayer] is used to selected a specific source layer from
  /// Raster source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  Future<void> addHillshadeLayer(String sourceId, String layerId, HillshadeLayerProperties properties,
      {String? belowLayerId, String? sourceLayer, double? minzoom, double? maxzoom}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addHillshadeLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
    );
  }

  /// Add a heatmap layer to the map with the given properties
  ///
  /// Consider using [addLayer] for an unified layer api.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// [sourceLayer] is used to selected a specific source layer from
  /// Raster source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  Future<void> addHeatmapLayer(String sourceId, String layerId, HeatmapLayerProperties properties,
      {String? belowLayerId, String? sourceLayer, double? minzoom, double? maxzoom}) async {
    _disposeGuard();
    await _nbMapsGlPlatform.addHeatmapLayer(
      sourceId,
      layerId,
      properties.toJson(),
      belowLayerId: belowLayerId,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
    );
  }

  /// Updates user location tracking mode.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> updateMyLocationTrackingMode(MyLocationTrackingMode myLocationTrackingMode) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.updateMyLocationTrackingMode(myLocationTrackingMode);
  }

  /// Updates the language of the map labels to match the device's language.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> matchMapLanguageWithDeviceDefault() async {
    _disposeGuard();
    return await _nbMapsGlPlatform.matchMapLanguageWithDeviceDefault();
  }

  /// Updates the distance from the edges of the map view’s frame to the edges
  /// of the map view’s logical viewport, optionally animating the change.
  ///
  /// When the value of this property is equal to `EdgeInsets.zero`, viewport
  /// properties such as centerCoordinate assume a viewport that matches the map
  /// view’s frame. Otherwise, those properties are inset, excluding part of the
  /// frame from the viewport. For instance, if the only the top edge is inset,
  /// the map center is effectively shifted downward.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> updateContentInsets(EdgeInsets insets, [bool animated = false]) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.updateContentInsets(insets, animated);
  }

  /// Updates the language of the map labels to match the specified language.
  /// Attention: This may only be called after onStyleLoaded() has been invoked.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> setMapLanguage(String language) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.setMapLanguage(language);
  }

  /// Enables or disables the collection of anonymized telemetry data.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  Future<void> setTelemetryEnabled(bool enabled) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.setTelemetryEnabled(enabled);
  }

  /// Retrieves whether collection of anonymized telemetry data is enabled.
  ///
  /// The returned [Future] completes after the query has been made on the
  /// platform side.
  Future<bool> getTelemetryEnabled() async {
    _disposeGuard();
    return await _nbMapsGlPlatform.getTelemetryEnabled();
  }

  /// Adds a symbol to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the symbol has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added symbol once listeners have
  /// been notified.
  Future<Symbol> addSymbol(SymbolOptions options, [Map? data]) async {
    _disposeGuard();
    final effectiveOptions = SymbolOptions.defaultOptions.copyWith(options);
    final symbol = Symbol(getRandomString(), effectiveOptions, data);
    await symbolManager!.add(symbol);
    notifyListeners();
    return symbol;
  }

  /// Adds multiple symbols to the map, configured using the specified custom
  /// [options].
  ///
  /// Change listeners are notified once the symbol has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added symbol once listeners have
  /// been notified.
  Future<List<Symbol>> addSymbols(List<SymbolOptions> options, [List<Map>? data]) async {
    _disposeGuard();
    final symbols = [
      for (var i = 0; i < options.length; i++)
        Symbol(getRandomString(), SymbolOptions.defaultOptions.copyWith(options[i]), data?[i])
    ];
    await symbolManager!.addAll(symbols);

    notifyListeners();
    return symbols;
  }

  /// Updates the specified [symbol] with the given [changes]. The symbol must
  /// be a current member of the [symbols] set.
  ///
  /// Change listeners are notified once the symbol has been updated on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> updateSymbol(Symbol symbol, SymbolOptions changes) async {
    _disposeGuard();
    await symbolManager!.set(symbol..options = symbol.options.copyWith(changes));

    notifyListeners();
  }

  /// Retrieves the current position of the symbol.
  /// This may be different from the value of `symbol.options.geometry` if the symbol is draggable.
  /// In that case this method provides the symbol's actual position, and `symbol.options.geometry` the last programmatically set position.
  Future<LatLng> getSymbolLatLng(Symbol symbol) async {
    _disposeGuard();
    return symbol.options.geometry!;
  }

  /// Removes the specified [symbol] from the map. The symbol must be a current
  /// member of the [symbols] set.
  ///
  /// Change listeners are notified once the symbol has been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeSymbol(Symbol symbol) async {
    _disposeGuard();
    await symbolManager!.remove(symbol);
    notifyListeners();
  }

  /// Removes the specified [symbols] from the map. The symbols must be current
  /// members of the [symbols] set.
  ///
  /// Change listeners are notified once the symbol has been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeSymbols(Iterable<Symbol> symbols) async {
    _disposeGuard();
    await symbolManager!.removeAll(symbols);
    notifyListeners();
  }

  /// Removes all [symbols] from the map.
  ///
  /// Change listeners are notified once all symbols have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> clearSymbols() async {
    _disposeGuard();
    symbolManager!.clear();
    notifyListeners();
  }

  /// Adds a line to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the line has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added line once listeners have
  /// been notified.
  Future<Line> addLine(LineOptions options, [Map? data]) async {
    _disposeGuard();
    final effectiveOptions = LineOptions.defaultOptions.copyWith(options);
    final line = Line(getRandomString(), effectiveOptions, data);
    await lineManager!.add(line);
    notifyListeners();
    return line;
  }

  /// Adds multiple lines to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the lines have been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added line once listeners have
  /// been notified.
  Future<List<Line>> addLines(List<LineOptions> options, [List<Map>? data]) async {
    _disposeGuard();
    final lines = [
      for (var i = 0; i < options.length; i++)
        Line(getRandomString(), LineOptions.defaultOptions.copyWith(options[i]), data?[i])
    ];
    await lineManager!.addAll(lines);

    notifyListeners();
    return lines;
  }

  /// Updates the specified [line] with the given [changes]. The line must
  /// be a current member of the [lines] set.‚
  ///
  /// Change listeners are notified once the line has been updated on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> updateLine(Line line, LineOptions changes) async {
    _disposeGuard();
    line.options = line.options.copyWith(changes);
    await lineManager!.set(line);
    notifyListeners();
  }

  /// Retrieves the current position of the line.
  /// This may be different from the value of `line.options.geometry` if the line is draggable.
  /// In that case this method provides the line's actual position, and `line.options.geometry` the last programmatically set position.
  Future<List<LatLng>> getLineLatLngs(Line line) async {
    _disposeGuard();
    return line.options.geometry!;
  }

  /// Removes the specified [line] from the map. The line must be a current
  /// member of the [lines] set.
  ///
  /// Change listeners are notified once the line has been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeLine(Line line) async {
    _disposeGuard();
    await lineManager!.remove(line);
    notifyListeners();
  }

  /// Removes the specified [lines] from the map. The lines must be current
  /// members of the [lines] set.
  ///
  /// Change listeners are notified once the lines have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeLines(Iterable<Line> lines) async {
    _disposeGuard();
    await lineManager!.removeAll(lines);
    notifyListeners();
  }

  /// Removes all [lines] from the map.
  ///
  /// Change listeners are notified once all lines have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> clearLines() async {
    _disposeGuard();
    await lineManager!.clear();
    notifyListeners();
  }

  /// Adds a circle to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the circle has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added circle once listeners have
  /// been notified.
  Future<Circle> addCircle(CircleOptions options, [Map? data]) async {
    _disposeGuard();
    final CircleOptions effectiveOptions = CircleOptions.defaultOptions.copyWith(options);
    final circle = Circle(getRandomString(), effectiveOptions, data);
    await circleManager!.add(circle);
    notifyListeners();
    return circle;
  }

  /// Adds multiple circles to the map, configured using the specified custom
  /// [options].
  ///
  /// Change listeners are notified once the circles have been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added circle once listeners have
  /// been notified.
  Future<List<Circle>> addCircles(List<CircleOptions> options, [List<Map>? data]) async {
    _disposeGuard();
    final cricles = [
      for (var i = 0; i < options.length; i++)
        Circle(getRandomString(), CircleOptions.defaultOptions.copyWith(options[i]), data?[i])
    ];
    await circleManager!.addAll(cricles);

    notifyListeners();
    return cricles;
  }

  /// Updates the specified [circle] with the given [changes]. The circle must
  /// be a current member of the [circles] set.
  ///
  /// Change listeners are notified once the circle has been updated on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> updateCircle(Circle circle, CircleOptions changes) async {
    _disposeGuard();
    circle.options = circle.options.copyWith(changes);
    await circleManager!.set(circle);

    notifyListeners();
  }

  /// Retrieves the current position of the circle.
  /// This may be different from the value of `circle.options.geometry` if the circle is draggable.
  /// In that case this method provides the circle's actual position, and `circle.options.geometry` the last programmatically set position.
  Future<LatLng> getCircleLatLng(Circle circle) async {
    _disposeGuard();
    return circle.options.geometry!;
  }

  /// Removes the specified [circle] from the map. The circle must be a current
  /// member of the [circles] set.
  ///
  /// Change listeners are notified once the circle has been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeCircle(Circle circle) async {
    _disposeGuard();
    await circleManager!.remove(circle);

    notifyListeners();
  }

  /// Removes the specified [circles] from the map. The circles must be current
  /// members of the [circles] set.
  ///
  /// Change listeners are notified once the circles have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeCircles(Iterable<Circle> circles) async {
    _disposeGuard();
    await circleManager!.removeAll(circles);
    notifyListeners();
  }

  /// Removes all [circles] from the map.
  ///
  /// Change listeners are notified once all circles have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> clearCircles() async {
    _disposeGuard();
    await circleManager!.clear();

    notifyListeners();
  }

  /// Adds a fill to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the fill has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added fill once listeners have
  /// been notified.
  Future<Fill> addFill(FillOptions options, [Map? data]) async {
    _disposeGuard();
    final FillOptions effectiveOptions = FillOptions.defaultOptions.copyWith(options);
    final fill = Fill(getRandomString(), effectiveOptions, data);
    await fillManager!.add(fill);
    notifyListeners();
    return fill;
  }

  /// Adds multiple fills to the map, configured using the specified custom
  /// [options].
  ///
  /// Change listeners are notified once the fills has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added fills once listeners have
  /// been notified.
  Future<List<Fill>> addFills(List<FillOptions> options, [List<Map>? data]) async {
    _disposeGuard();
    final fills = [
      for (var i = 0; i < options.length; i++)
        Fill(getRandomString(), FillOptions.defaultOptions.copyWith(options[i]), data?[i])
    ];
    await fillManager!.addAll(fills);

    notifyListeners();
    return fills;
  }

  /// Updates the specified [fill] with the given [changes]. The fill must
  /// be a current member of the [fills] set.
  ///
  /// Change listeners are notified once the fill has been updated on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> updateFill(Fill fill, FillOptions changes) async {
    _disposeGuard();
    fill.options = fill.options.copyWith(changes);
    await fillManager!.set(fill);

    notifyListeners();
  }

  /// Removes all [fill] from the map.
  ///
  /// Change listeners are notified once all fills have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> clearFills() async {
    _disposeGuard();
    await fillManager!.clear();

    notifyListeners();
  }

  /// Removes the specified [fill] from the map. The fill must be a current
  /// member of the [fills] set.
  ///
  /// Change listeners are notified once the fill has been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeFill(Fill fill) async {
    _disposeGuard();
    await fillManager!.remove(fill);
    notifyListeners();
  }

  /// Removes the specified [fills] from the map. The fills must be current
  /// members of the [fills] set.
  ///
  /// Change listeners are notified once the fills have been removed on the
  /// platform side.
  ///
  /// The returned [Future] completes once listeners have been notified.
  Future<void> removeFills(Iterable<Fill> fills) async {
    _disposeGuard();
    await fillManager!.removeAll(fills);
    notifyListeners();
  }

  /// Query rendered features at a point in screen cooridnates
  Future<List> queryRenderedFeatures(Point<double> point, List<String> layerIds, List<Object>? filter) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.queryRenderedFeatures(point, layerIds, filter);
  }

  /// Query rendered features in a Rect in screen coordinates
  Future<List> queryRenderedFeaturesInRect(Rect rect, List<String> layerIds, String? filter) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.queryRenderedFeaturesInRect(rect, layerIds, filter);
  }

  Future invalidateAmbientCache() async {
    _disposeGuard();
    return await _nbMapsGlPlatform.invalidateAmbientCache();
  }

  /// Get last my location
  ///
  /// Return last latlng, nullable
  Future<LatLng?> requestMyLocationLatLng() async {
    _disposeGuard();
    return await _nbMapsGlPlatform.requestMyLocationLatLng();
  }

  /// This method returns the boundaries of the region currently displayed in the map.
  Future<LatLngBounds> getVisibleRegion() async {
    _disposeGuard();
    return await _nbMapsGlPlatform.getVisibleRegion();
  }

  /// Update map style for MapView
  Future<void> setStyleString(String styleString) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.setStyleString(styleString);
  }

  /// Adds an image to the style currently displayed in the map, so that it can later be referred to by the provided name.
  ///
  /// This allows you to add an image to the currently displayed style once, and from there on refer to it e.g. in the [Symbol.iconImage] anytime you add a [Symbol] later on.
  /// Set [sdf] to true if the image you add is an SDF image.
  /// Returns after the image has successfully been added to the style.
  /// Note: This can only be called after OnStyleLoadedCallback has been invoked and any added images will have to be re-added if a new style is loaded.
  ///
  /// Example: Adding an asset image and using it in a new symbol:
  /// ```dart
  /// Future<void> addImageFromAsset() async{
  ///   final ByteData bytes = await rootBundle.load("assets/someAssetImage.jpg");
  ///   final Uint8List list = bytes.buffer.asUint8List();
  ///   await controller.addImage("assetImage", list);
  ///   controller.addSymbol(
  ///    SymbolOptions(
  ///     geometry: LatLng(0,0),
  ///     iconImage: "assetImage",
  ///    ),
  ///   );
  /// }
  /// ```
  ///
  /// Example: Adding a network image (with the http package) and using it in a new symbol:
  /// ```dart
  /// Future<void> addImageFromUrl() async{
  ///  var response = await get("https://example.com/image.png");
  ///  await controller.addImage("testImage",  response.bodyBytes);
  ///  controller.addSymbol(
  ///   SymbolOptions(
  ///     geometry: LatLng(0,0),
  ///     iconImage: "testImage",
  ///   ),
  ///  );
  /// }
  /// ```
  Future<void> addImage(String name, Uint8List bytes, [bool sdf = false]) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.addImage(name, bytes, sdf);
  }

  Future<void> setSymbolIconAllowOverlap(bool enable) async {
    _disposeGuard();
    await symbolManager?.setIconAllowOverlap(enable);
  }

  Future<void> setSymbolIconIgnorePlacement(bool enable) async {
    _disposeGuard();
    await symbolManager?.setIconIgnorePlacement(enable);
  }

  Future<void> setSymbolTextAllowOverlap(bool enable) async {
    _disposeGuard();
    await symbolManager?.setTextAllowOverlap(enable);
  }

  Future<void> setSymbolTextIgnorePlacement(bool enable) async {
    _disposeGuard();
    await symbolManager?.setTextIgnorePlacement(enable);
  }

  /// Adds an image source to the style currently displayed in the map, so that it can later be referred to by the provided id.
  Future<void> addImageSource(String imageSourceId, Uint8List bytes, LatLngQuad coordinates) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.addImageSource(imageSourceId, bytes, coordinates);
  }

  /// Update an image source to the style currently displayed in the map, so that it can later be referred to by the provided id.
  Future<void> updateImageSource(String imageSourceId, Uint8List? bytes, LatLngQuad? coordinates) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.updateImageSource(imageSourceId, bytes, coordinates);
  }

  /// Removes previously added image source by id
  @Deprecated("This method was renamed to removeSource")
  Future<void> removeImageSource(String imageSourceId) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.removeSource(imageSourceId);
  }

  /// Removes previously added source by id
  Future<void> removeSource(String sourceId) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.removeSource(sourceId);
  }

  /// Adds a NbMaps image layer to the map's style at render time.
  Future<void> addImageLayer(String layerId, String imageSourceId, {double? minzoom, double? maxzoom}) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.addLayer(layerId, imageSourceId, minzoom, maxzoom);
  }

  /// Adds a NbMaps image layer below the layer provided with belowLayerId to the map's style at render time.
  Future<void> addImageLayerBelow(String layerId, String sourceId, String imageSourceId,
      {double? minzoom, double? maxzoom}) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.addLayerBelow(layerId, sourceId, imageSourceId, minzoom, maxzoom);
  }

  /// Adds a NbMaps image layer below the layer provided with belowLayerId to the map's style at render time. Only works for image sources!
  @Deprecated("This method was renamed to addImageLayerBelow for clarity.")
  Future<void> addLayerBelow(String layerId, String sourceId, String imageSourceId,
      {double? minzoom, double? maxzoom}) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.addLayerBelow(layerId, sourceId, imageSourceId, minzoom, maxzoom);
  }

  /// Removes a nbmaps style layer
  Future<void> removeLayer(String layerId) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.removeLayer(layerId);
  }

  Future<void> setFilter(String layerId, dynamic filter) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.setFilter(layerId, filter);
  }

  /// Sets the visibility by specifying [isVisible] of the layer with
  /// the specified id [layerId].
  /// Returns silently if [layerId] does not exist.
  Future<void> setVisibility(String layerId, bool isVisible) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.setVisibility(layerId, isVisible);
  }

  /// Returns the point on the screen that corresponds to a geographical coordinate ([latLng]). The screen location is in screen pixels (not display pixels) relative to the top left of the map (not of the whole screen)
  ///
  /// Note: The resulting x and y coordinates are rounded to [int] on web, on other platforms they may differ very slightly (in the range of about 10^-10) from the actual nearest screen coordinate.
  /// You therefore might want to round them appropriately, depending on your use case.
  ///
  /// Returns null if [latLng] is not currently visible on the map.
  Future<Point> toScreenLocation(LatLng latLng) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.toScreenLocation(latLng);
  }

  Future<List<Point>> toScreenLocationBatch(Iterable<LatLng> latLngs) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.toScreenLocationBatch(latLngs);
  }

  /// Returns the geographic location (as [LatLng]) that corresponds to a point on the screen. The screen location is specified in screen pixels (not display pixels) relative to the top left of the map (not the top left of the whole screen).
  Future<LatLng> toLatLng(Point screenLocation) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.toLatLng(screenLocation);
  }

  /// Returns the distance spanned by one pixel at the specified [latitude] and current zoom level.
  /// The distance between pixels decreases as the latitude approaches the poles. This relationship parallels the relationship between longitudinal coordinates at different latitudes.
  Future<double> getMetersPerPixelAtLatitude(double latitude) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.getMetersPerPixelAtLatitude(latitude);
  }

  /// Add a new source to the map
  Future<void> addSource(String sourceid, SourceProperties properties) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.addSource(sourceid, properties);
  }

  /// Add a layer to the map with the given properties
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side. If the layer already exists, the layer is updated.
  ///
  /// Setting [belowLayerId] adds the new layer below the given id.
  /// If [enableInteraction] is set the layer is considered for touch or drag
  /// events this has no effect for [RasterLayerProperties] and
  /// [HillshadeLayerProperties].
  /// [sourceLayer] is used to selected a specific source layer from Vector
  /// source.
  /// [minzoom] is the minimum (inclusive) zoom level at which the layer is
  /// visible.
  /// [maxzoom] is the maximum (exclusive) zoom level at which the layer is
  /// visible.
  /// [filter] determines which features should be rendered in the layer.
  /// Filters are written as [expressions].
  /// [filter] is not supported by RasterLayer and HillshadeLayer.
  ///
  Future<void> addLayer(String sourceId, String layerId, LayerProperties properties,
      {String? belowLayerId,
      bool enableInteraction = true,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter}) async {
    _disposeGuard();
    if (properties is FillLayerProperties) {
      addFillLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId,
          enableInteraction: enableInteraction,
          sourceLayer: sourceLayer,
          minzoom: minzoom,
          maxzoom: maxzoom,
          filter: filter);
    } else if (properties is FillExtrusionLayerProperties) {
      addFillExtrusionLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId, sourceLayer: sourceLayer, minzoom: minzoom, maxzoom: maxzoom);
    } else if (properties is LineLayerProperties) {
      addLineLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId,
          enableInteraction: enableInteraction,
          sourceLayer: sourceLayer,
          minzoom: minzoom,
          maxzoom: maxzoom,
          filter: filter);
    } else if (properties is SymbolLayerProperties) {
      addSymbolLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId,
          enableInteraction: enableInteraction,
          sourceLayer: sourceLayer,
          minzoom: minzoom,
          maxzoom: maxzoom,
          filter: filter);
    } else if (properties is CircleLayerProperties) {
      addCircleLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId,
          enableInteraction: enableInteraction,
          sourceLayer: sourceLayer,
          minzoom: minzoom,
          maxzoom: maxzoom,
          filter: filter);
    } else if (properties is RasterLayerProperties) {
      if (filter != null) {
        throw UnimplementedError("RasterLayer does not support filter");
      }
      addRasterLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId, sourceLayer: sourceLayer, minzoom: minzoom, maxzoom: maxzoom);
    } else if (properties is HillshadeLayerProperties) {
      if (filter != null) {
        throw UnimplementedError("HillShadeLayer does not support filter");
      }
      addHillshadeLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId, sourceLayer: sourceLayer, minzoom: minzoom, maxzoom: maxzoom);
    } else if (properties is HeatmapLayerProperties) {
      addHeatmapLayer(sourceId, layerId, properties,
          belowLayerId: belowLayerId, sourceLayer: sourceLayer, minzoom: minzoom, maxzoom: maxzoom);
    } else {
      throw UnimplementedError("Unknown layer type $properties");
    }
  }

  /// Generates static raster images of the map. Each snapshot image depicts a portion of a map defined by an [SnapshotOptions] object you provide
  /// Android/iOS: Return snapshot uri in app specific cache storage or base64 string
  /// Web: Return base64 string with current camera posision of [NBMap]
  ///
  /// Default will return snapshot uri in Android and iOS
  /// If you want base64 value, you must set writeToDisk option to False
  Future<String> takeSnapshot(SnapshotOptions snapshotOptions) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.takeSnapshot(snapshotOptions);
  }

  Future<String> findBelowLayerId(List<String> belowAt) async {
    _disposeGuard();
    return await _nbMapsGlPlatform.findBelowLayerId(belowAt);
  }

  void _disposeGuard() {
    if (_disposed) {
      throw StateError(
        'This NextbillionMapController has already been disposed. This happens if flutter disposes a NBMap and you try to use its Controller afterwards.',
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    _nbMapsGlPlatform.dispose();
  }
}
