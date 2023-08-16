package ai.nextbillion.maps_flutter;

import android.content.Context;

import androidx.annotation.NonNull;

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
                break;
            case "nextbillion/get_access_key":
                String accessTokenResult = NbMapUtils.getAccessKey();
                result.success(accessTokenResult);
                break;
            case "nextbillion/set_access_key":
                String accessTokenToSet = call.argument("accessKey");
                NbMapUtils.setAccessKey(accessTokenToSet);
                break;
            case "nextbillion/get_base_uri":
                String baseUri = NbMapUtils.getBaseUri();
                result.success(baseUri);
                break;
            case "nextbillion/set_base_uri":
                String baseUriToSet = call.argument("baseUri");
                NbMapUtils.setBaseUri(baseUriToSet);
                break;
        }

    }
}