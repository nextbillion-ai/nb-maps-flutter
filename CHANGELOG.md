## v0.4.1, June 5, 2024
* Add setUserId method to NextBillion
* Add getUserId method to NextBillion
* Add getNbId method to NextBillion
## v0.4.0, May 29, 2024
* Remove state check exception when calling methods of NextbillionMapController after the controller is disposed

## v0.3.5, May 7, 2024
* Add result for NextBillion methods

## v0.3.4, May 7, 2024
* Add await for some methods in controller
* Support obtaining the disposed status from the controller

## v0.3.2, Apr 29, 2024
* Update Android NB Maps SDK to 1.1.0
* Update iOS NB Maps framework to 1.1.0

## v0.3.1, Apr 24, 2024
* Throw an exception when calling methods of NextbillionMapController after the controller is disposed

## v0.3.0, Nov 8, 2023
* Update Android NB Maps SDK to 1.0.3

## v0.2.0, Sept 26, 2023
* Update iOS NB Maps framework to 1.0.3
* Update Android NB Maps SDK to 1.0.2
* Support to fit camera into bounds with multi points

## v0.1.6, Sept 15, 2023
* Fix the animateCamera issue
  * When calling controller.animateCamera() within onStyleLoadedCallback 

## v0.1.5, Aug 17, 2023
* Update Android NB Maps SDK to 1.0.0
* Update the default map style

## v0.1.4, Aug 16, 2023
* Update iOS NB Maps framework to 1.0.2
* Support to change the base url of map style url
* Update the default map style

## v0.1.0, July 20, 2023
* Display MapView
  * Camera position
  * Map Click Callback
  * OnMapLongClickCallback
  * MapView Created callback
  * Map Style loaded callback
* Map Options
  * Map Style String
  * Enable Map Compass
  * Enable zoom/scroll/tilt/rotate gestures
  * Enable User Location
  * Config Location Tracking Mode
  * Config Location Render Mode
* Location Component
  * Tracking Current location
  * Get Current location
  * OnLocationUpdate Callback
* Camera API
  * Animate Camera
  * Move Camera
  * OnCameraTrackingDismissedCallback
  * OnCameraTrackingChangedCallback
  * OnCameraIdleCallback
* Annotations View
  * Symbol annotation
  * Line annotation
  * Fill annotation
  * Circle annotation
  * Add Asset Image Symbol
* Query Features
* Customize source & layers
  * GeoJson Source
  * Image Source
  * Raster Source
  * Vector Source
  * Hillshade Layer
  * Fill Layer
  * Line Layer
  * Circle Layer
  * Symbol Layer
  * Raster Layer

## v0.1.4, August 16, 2023
* Update iOS native framework version from 1.0.1 to 1.0.2