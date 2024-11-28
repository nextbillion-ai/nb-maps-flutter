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

    static String getAccessKey() {
        String accessToken = Nextbillion.getAccessKey();
        if (accessToken == null || accessToken.isEmpty()) {
            throw new NbmapConfigurationException("\n Access Key is not set or Access Key is empty");
        }
        return accessToken;
    }

    static void setAccessKey(String accessToken) {
        if (accessToken == null || accessToken.isEmpty()) {
            throw new NbmapConfigurationException("\n Access Key should not be empty");
        }
        Nextbillion.setAccessKey(accessToken);
    }

    static String getBaseUri() {
        String baseUri = Nextbillion.getBaseUri();
        if (baseUri == null || baseUri.isEmpty()) {
            throw new NbmapConfigurationException("\n BaseUri is not set or BaseUri is empty");
        }
        return baseUri;
    }

    static void setBaseUri(String baseUri) {
        if (baseUri == null || baseUri.isEmpty()) {
            throw new NbmapConfigurationException("\n BaseUri should not be empty");
        }
        Nextbillion.setBaseUri(baseUri);
    }

    static void setApiKeyHeaderName(String apiKeyHeaderName) {
        if (apiKeyHeaderName == null || apiKeyHeaderName.isEmpty()) {
            throw new NbmapConfigurationException("\n Api Key Header Name should not be empty");
        }
        Nextbillion.setApiKeyHeaderName(apiKeyHeaderName);
    }

    static String getApiKeyHeaderName() {
        return Nextbillion.getApiKeyHeaderName();
    }

    static String getUserid() {
        return Nextbillion.getUserId();
    }

    static void setUserid(String userid) {
        Nextbillion.setUserId(userid);
    }

    static String getNbId() {
        return Nextbillion.getNBId();
    }

    static void setCrossPlatformInfo() {
        String crossPlatformName = String.format("Flutter-%s-%s", BuildConfig.NBMAP_FLUTTER_VERSION, BuildConfig.GIT_REVISION_SHORT);
        Nextbillion.setCrossPlatformInfo(crossPlatformName);
    }


}
