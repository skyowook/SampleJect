package com.skw.samplejectaos.activity

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.webkit.CookieManager
import android.webkit.WebStorage
import android.webkit.WebViewDatabase
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.google.gson.Gson
import com.skw.samplejectaos.common.createTrustManager
import com.skw.samplejectaos.data.PemCertificateData
import com.skw.samplejectaos.databinding.ActivitySslTestBinding
import com.skw.samplejectaos.network.SSLTestApi
import com.skw.samplejectaos.web.SSLTestWebViewClient
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.await
import retrofit2.converter.gson.GsonConverterFactory
import java.lang.Exception
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.concurrent.TimeUnit
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

@AndroidEntryPoint
class SSLTestActivity: AppCompatActivity() {
    var sslTestApi: SSLTestApi? = null

    companion object {
        const val TEST_URL = "https://dev-smart.kisb.co.kr"
//        const val TEST_URL = "https://m.naver.com"

        // FIXME
        private val elData = """
            {
              "elData": {
                "REQ_DATA": {
                  "OS": "ANDROID"
                }
              }
            }
             """.trimIndent()
        private val versionRequestParams: RequestBody
            get() {
                return elData.toRequestBody()
            }
    }

    private lateinit var bind: ActivitySslTestBinding
    private lateinit var sslWebViewClient: SSLTestWebViewClient
    private var model: PemCertificateData? = null

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        bind = ActivitySslTestBinding.inflate(layoutInflater)
        setContentView(bind.root)

        requestPemData()

        bind.btnLoad.setOnClickListener {
            bind.webview.loadUrl(TEST_URL)
        }

        bind.btnCallApi.setOnClickListener {
            requestCallApi()
        }

        bind.sCertificateOnoff.setOnCheckedChangeListener { compoundButton, isCheck ->
            val enablePem = if (isCheck) model?.new ?: "" else model?.old ?: ""
            updatePem(enablePem)
        }
    }

   @SuppressLint("SetJavaScriptEnabled")
   private fun updatePem(pemString: String) {
       val cookieManager = CookieManager.getInstance()
       cookieManager.removeAllCookies(null)
       cookieManager.removeSessionCookies(null)
       cookieManager.flush()

       WebViewDatabase.getInstance(this).clearHttpAuthUsernamePassword()
       WebStorage.getInstance().deleteAllData()

       bind.webview.loadUrl("https://m.naver.com")
       sslWebViewClient = SSLTestWebViewClient()
       sslWebViewClient.setPemString(pemString)
       sslTestApi = createSSLTestApi(pemString)

       bind.webview.apply {
           webViewClient = sslWebViewClient
           settings.javaScriptEnabled = true
           clearHistory()
           clearCache(true)
           clearFormData()
           clearSslPreferences()
       }
   }

    private fun requestPemData() {
        lifecycleScope.launch {
            try {
                val pemData = createPemCertificateApi()?.getPemCertificate()?.await()
                Log.i("test", pemData?.old ?: "")
                Log.i("test", pemData?.new ?: "")

                model = pemData
                val enablePem = pemData?.new ?: ""
                bind.sCertificateOnoff.isChecked = enablePem == pemData?.new

                updatePem(enablePem)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun requestCallApi() {
        lifecycleScope.launch {
            try {
                val test = sslTestApi?.getAppVersion(versionRequestParams)?.await()
                Log.d("test", Gson().toJson(test))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun createPemCertificateApi(): SSLTestApi? {
        val okHttpClientBuilder: OkHttpClient.Builder = getUnsafeOkHttpClient()
            .callTimeout(30, TimeUnit.SECONDS)
            .connectTimeout(30, TimeUnit.SECONDS)

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
            .baseUrl("https://hosting-4e3b6.web.app")
            .client(okHttpClientBuilder.build())
            .build()
            .create(SSLTestApi::class.java)
    }

    private fun getUnsafeOkHttpClient(): OkHttpClient.Builder {
        val trustAllCerts = arrayOf<TrustManager>(object : X509TrustManager {
            @SuppressLint("TrustAllX509TrustManager")
            override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}

            @SuppressLint("TrustAllX509TrustManager")
            override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {}

            override fun getAcceptedIssuers(): Array<X509Certificate> { return arrayOf() }
        })

        val sslContext = SSLContext.getInstance("SSL")
        sslContext.init(null, trustAllCerts, SecureRandom())

        val sslSocketFactory = sslContext.socketFactory
        val builder = OkHttpClient.Builder()
        builder.sslSocketFactory(sslSocketFactory, trustAllCerts[0] as X509TrustManager)
        builder.hostnameVerifier { hostname, session -> true }

        return builder
    }

    private fun createSSLTestApi(pemString: String): SSLTestApi? {
        val tmfactory = createTrustManager(pemString)
        // Create an SSLContext that uses our TrustManager
        val context: SSLContext = SSLContext.getInstance("TLS").apply {
            init(null, tmfactory.trustManagers, null)
        }

        // 이걸써서 API 통신 모듈 (Retrofit)에 주면 인증서 전달가능.
        for (manager in tmfactory.trustManagers) {
            if (manager is X509TrustManager) {
                val okHttpClientBuilder: OkHttpClient.Builder = OkHttpClient.Builder()
                    .sslSocketFactory(context.socketFactory, manager)
                    .callTimeout(30, TimeUnit.SECONDS)
                    .connectTimeout(30, TimeUnit.SECONDS)


                return Retrofit.Builder()
                    .addConverterFactory(GsonConverterFactory.create(Gson()))
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .baseUrl("https://dev-smart.kisb.co.kr")
                    .client(okHttpClientBuilder.build())
                    .build()
                    .create(SSLTestApi::class.java)
            }
        }

        return null
    }
}