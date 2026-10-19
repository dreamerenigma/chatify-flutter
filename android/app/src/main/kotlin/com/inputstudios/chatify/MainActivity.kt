package com.inputstudios.chatify

import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.BitmapFactory
import android.graphics.drawable.Icon
import android.os.Build

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.inputstudios.chatify/passkey"
    private val channelName = "com.inputstudios.chatify/shortcuts"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "createPasskey") {
                result.error("UNSUPPORTED", "Passkey временно отключен", null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method != "pinChatShortcut") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                result.error("UNSUPPORTED", "Требуется Android 8.0 или новее", null)
                return@setMethodCallHandler
            }

            val userId: String? = call.argument("userId")
            val username: String = call.argument<String>("username") ?: "Контакт"
            val imageBytes: ByteArray? = call.argument("imageBytes")

            if (userId.isNullOrBlank()) {
                result.error("INVALID_USER", "Не указан ID контакта", null)
                return@setMethodCallHandler
            }

            try {
                val shortcutManager: ShortcutManager = getSystemService(ShortcutManager::class.java)

                if (!shortcutManager.isRequestPinShortcutSupported) {
                    result.error("UNSUPPORTED", "Рабочий стол не поддерживает закрепление ярлыков", null)
                    return@setMethodCallHandler
                }

                val launchIntent = Intent(this@MainActivity, MainActivity::class.java)

                launchIntent.action = Intent.ACTION_VIEW
                launchIntent.putExtra("openChatUserId", userId)
                launchIntent.putExtra("openChatUsername", username)
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)

                var shortcutIcon: Icon? = null

                if (imageBytes != null && imageBytes.isNotEmpty()) {
                    val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

                    if (bitmap != null) {
                        shortcutIcon = Icon.createWithBitmap(bitmap)
                    }
                }

                if (shortcutIcon == null) {
                    shortcutIcon = Icon.createWithResource(this@MainActivity, R.mipmap.ic_launcher)
                }

                val shortcut = ShortcutInfo.Builder(this@MainActivity, "chat_$userId")
                    .setShortLabel(username.take(40))
                    .setLongLabel("Чат с $username")
                    .setIcon(shortcutIcon)
                    .setIntent(launchIntent)
                    .build()

                val accepted: Boolean =
                    shortcutManager.requestPinShortcut(shortcut, null)

                result.success(accepted)

            } catch (e: Exception) {
                result.error("SHORTCUT_ERROR", e.message ?: "Не удалось создать ярлык", null)
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}
