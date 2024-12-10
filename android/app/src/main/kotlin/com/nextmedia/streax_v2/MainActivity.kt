package com.nextmedia.streax_v2

import android.os.Bundle
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.pm.ActivityInfo

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set orientation to portrait mode
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT

        // Initialize the Snapchat Camera Kit SDK


        // Reset orientation settings if necessary
    }
}




