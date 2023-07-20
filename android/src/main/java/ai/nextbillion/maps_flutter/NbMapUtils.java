package ai.nextbillion.maps_flutter;

import android.content.Context;

import ai.nextbillion.maps.Nextbillion;
import ai.nextbillion.maps.exceptions.NbmapConfigurationException;

abstract class NbMapUtils {
  private static final String TAG = "NbMapController";

  static Nextbillion getNextbillion(Context context, String accessToken) {
    if (accessToken == null || accessToken.isEmpty()) {
      throw new NbmapConfigurationException("\nUsing MapView requires calling Nextbillion.initNextbillion(String accessKey) before inflating or creating NBMap Widget. The accessKey parameter is required when using a NBMap Widget.");
    }
    return Nextbillion.getInstance(context.getApplicationContext(), accessToken);
  }

}
