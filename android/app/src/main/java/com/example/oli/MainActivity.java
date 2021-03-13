package com.example.oli;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import android.util.Log;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onStop() {
        super.onStop();
        Log.i("=== MainActivity ===", "onStop: ");
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "flutter.temp.channel").invokeMethod("destroy", null, null);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.i("=== MainActivity ===", "onDestroy: ");
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "flutter.temp.channel").invokeMethod("destroy", null, null);
    }
}
