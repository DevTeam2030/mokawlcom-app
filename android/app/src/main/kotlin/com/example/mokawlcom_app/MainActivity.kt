package com.example.mokawlcom_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : FlutterActivity() {
    // Pre-warm Flutter engine for faster startup
    companion object {
        const val ENGINE_ID = "mokawlcom_engine"
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register plugins here if needed for optimization
    }
}
