
package ai.nextbillion.maps_flutter;


import ai.nextbillion.maps.camera.CameraPosition;

interface OnCameraMoveListener {
  void onCameraMoveStarted(boolean isGesture);

  void onCameraMove(CameraPosition newPosition);

  void onCameraIdle();
}
