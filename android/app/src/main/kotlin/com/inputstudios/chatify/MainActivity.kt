package com.inputstudios.chatify

import android.os.Bundle
import androidx.credentials.CredentialManager
import androidx.credentials.CreatePublicKeyCredentialRequest
import androidx.credentials.PublicKeyCredential
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.inputstudios.chatify/passkey"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "createPasskey") {
                    createPasskey(result)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun createPasskey(result: MethodChannel.Result) {
        val credentialManager = CredentialManager.create(this)

        val requestJson = JSONObject().apply {
            put("challenge", "abc123")
            put("rp", JSONObject().put("name", "Chatify").put("id", "chatify.app"))
            put("user", JSONObject().put("id", "123").put("name", "test@example.com").put("displayName", "Test User"))
            put("pubKeyCredParams", listOf(JSONObject().put("alg", -7).put("type", "public-key")))
        }.toString()

        val request = CreatePublicKeyCredentialRequest(requestJson)

        CoroutineScope(Dispatchers.Main).launch {
            try {
                val response = credentialManager.createCredential(this@MainActivity, request, null)
                val credential = response.credential as? PublicKeyCredential
                val json = credential?.authenticationResponseJson
                result.success(json)
            } catch (e: Exception) {
                result.error("PASSKEY_ERROR", "Ошибка: ${e.message}", null)
            }
        }
    }
}
