package com.example.instagram_clone

import android.os.Bundle
// import androidx.appcompat.app.AppCompatDelegate;
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  //static{
    // AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
  //}

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
