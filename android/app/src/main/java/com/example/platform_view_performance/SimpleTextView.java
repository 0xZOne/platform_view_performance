package com.example.platform_view_performance;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;
import java.util.Random;

class SimpleTextView implements PlatformView {
  private final String TAG = "SimpleTextView";
  @NonNull private final TextView textView;
  private int id;

  private int getRandomColor() {
    Random rnd = new Random();
    return Color.argb(255, rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256));
  }

  SimpleTextView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
    this.id = id;
    textView = new TextView(context);
    textView.setTextSize(16);

    textView.setBackgroundColor(getRandomColor());
    textView.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);

    StringBuilder sb = new StringBuilder();
    sb.append("Native Android view (id: " + id + ")\n\n");
    for (Map.Entry<String, Object> entry : creationParams.entrySet()) {
      sb.append(entry.getKey() + ": " + entry.getValue().toString()).append("\n");
    }
    textView.setTextColor(Color.WHITE);
    textView.setText(sb.toString());

    textView.setOnTouchListener(new View.OnTouchListener() {
      @Override
      public boolean onTouch(View v, MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_UP) {
          textView.setBackgroundColor(getRandomColor());
        }
        Log.e(TAG, "#onTouch " + event.getAction());
        return true;
      }
    });
    Log.e(TAG, "#SimpleTextView: <ctor> " + sb.toString());
  }

  @NonNull
  @Override
  public View getView() {
    return textView;
  }

  @Override
  public void onFlutterViewAttached(@NonNull View flutterView) {
    Log.e(TAG, "#SimpleTextView#onFlutterViewAttached, " + flutterView);
  }

  @Override
  public void onFlutterViewDetached() {
    Log.e(TAG, "#SimpleTextView#onFlutterViewDetached");
  }

  @Override
  public void dispose() {
    Log.e(TAG, "#SimpleTextView#dispose~~ id=" + id);
  }
}