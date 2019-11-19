package io.flutter.plugins;

import android.os.Bundle;


import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.teamblnd/imgclassif";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("getClassificationResult")) {

                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }


    private boolean getClassificationResult(String imgPath) {
        //TODO: ADD AutoML Vision HERE
        return false;
    }


}
