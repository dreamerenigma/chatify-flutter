package com.inputstudios.chatify

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.inputstudios.chatify/passkey"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                // Заглушка — ничего не делает, но позволяет собрать проект
                if (call.method == "createPasskey") {
                    result.error("UNSUPPORTED", "Passkey временно отключен", null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
