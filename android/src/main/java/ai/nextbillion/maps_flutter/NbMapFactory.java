package ai.nextbillion.maps_flutter;

import android.content.Context;

import java.util.Map;

import ai.nextbillion.maps.camera.CameraPosition;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

import static ai.nextbillion.maps_flutter.Convert.interpretNextbillionMapOptions;

public class NbMapFactory extends PlatformViewFactory {

  private final BinaryMessenger messenger;
  private final NbMapsPlugin.LifecycleProvider lifecycleProvider;

  public NbMapFactory(
      BinaryMessenger messenger, NbMapsPlugin.LifecycleProvider lifecycleProvider) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
    this.lifecycleProvider = lifecycleProvider;
  }

  @Override
  public PlatformView create(Context context, int id, Object args) {
    Map<String, Object> params = (Map<String, Object>) args;
    final NbMapBuilder builder = new NbMapBuilder();

    interpretNextbillionMapOptions(params.get("options"), builder, context);
    if (params.containsKey("initialCameraPosition")) {
      CameraPosition position = Convert.toCameraPosition(params.get("initialCameraPosition"));
      builder.setInitialCameraPosition(position);
    }
    if (params.containsKey("dragEnabled")) {
      boolean dragEnabled = Convert.toBoolean(params.get("dragEnabled"));
      builder.setDragEnabled(dragEnabled);
    }

    return builder.build(
        id, context, messenger, lifecycleProvider);
  }
}
