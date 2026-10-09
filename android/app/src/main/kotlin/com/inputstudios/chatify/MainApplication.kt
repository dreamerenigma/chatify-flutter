package com.inputstudios.chatify

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        MapKitFactory.setApiKey("f021a4be-16d2-48e9-bd69-809f89f9d4c6")
        MapKitFactory.setLocale("ru_RU")
    }
}