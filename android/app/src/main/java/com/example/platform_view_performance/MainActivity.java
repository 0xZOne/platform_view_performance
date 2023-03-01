package com.example.platform_view_performance;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.RenderMode;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        flutterEngine
            .getPlatformViewsController()
            .getRegistry()
            .registerViewFactory("<simple-text-view>", new NativeViewFactory());
    }

    @Override
    public RenderMode getRenderMode() {
        // return RenderMode.surface;
        return RenderMode.texture;
    }
}
