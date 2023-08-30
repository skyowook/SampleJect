package com.skw.tosssampleaos

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class TossApplication: Application() {
    override fun onCreate() {
        super.onCreate()
    }
}