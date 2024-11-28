package ai.nextbillion.maps_flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import ai.nextbillion.maps.Nextbillion;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * @author qiuyu
 * @Date 2023/7/13
 **/
public class NextBillionMethodHandler implements MethodChannel.MethodCallHandler {

    @NonNull
    private final Context context;

    NextBillionMethodHandler(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        this.context = binding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "nextbillion/init_nextbillion":
                String accessToken = call.argument("accessKey");
                NbMapUtils.getNextbillion(context, accessToken);
                NbMapUtils.setCrossPlatformInfo();
                result.success(null);
                break;
            case "nextbillion/get_access_key":
                String accessTokenResult = NbMapUtils.getAccessKey();
                result.success(accessTokenResult);
                break;
            case "nextbillion/set_access_key":
                String accessTokenToSet = call.argument("accessKey");
                NbMapUtils.setAccessKey(accessTokenToSet);
                result.success(null);
                break;
            case "nextbillion/get_base_uri":
                String baseUri = NbMapUtils.getBaseUri();
                result.success(baseUri);
                break;
            case "nextbillion/set_base_uri":
                String baseUriToSet = call.argument("baseUri");
                NbMapUtils.setBaseUri(baseUriToSet);
                result.success(null);
                break;
            case "nextbillion/set_key_header_name":
                String apiKeyHeaderName = call.argument("apiKeyHeaderName");
                NbMapUtils.setApiKeyHeaderName(apiKeyHeaderName);
                result.success(null);
                break;
            case "nextbillion/get_key_header_name":
                String keyHeaderName = NbMapUtils.getApiKeyHeaderName();
                result.success(keyHeaderName);
                break;
            case "nextbillion/get_nb_id":
                String nbId = NbMapUtils.getNbId();
                result.success(nbId);
                break;
            case "nextbillion/set_user_id":
                String id = call.argument("userId");
                NbMapUtils.setUserid(id);
                result.success(null);
                break;
            case "nextbillion/get_user_id":
                String userId = NbMapUtils.getUserid();
                result.success(userId);
                break;

            default:
                result.notImplemented();
        }

    }
}