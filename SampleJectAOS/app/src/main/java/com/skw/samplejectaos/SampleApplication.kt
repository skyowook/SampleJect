package com.skw.samplejectaos

import android.app.Application
import android.util.Log
import androidx.lifecycle.lifecycleScope
import dagger.hilt.android.HiltAndroidApp
import kotlinx.coroutines.launch
import retrofit2.await
import java.io.BufferedInputStream
import java.io.InputStream
import java.lang.Exception
import java.security.KeyStore
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManagerFactory

@HiltAndroidApp
class SampleApplication: Application() {

    override fun onCreate() {
        super.onCreate()

    }
}