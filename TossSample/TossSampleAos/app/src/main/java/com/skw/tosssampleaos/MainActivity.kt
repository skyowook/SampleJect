package com.skw.tosssampleaos

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.webkit.JavascriptInterface
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.skw.tosssampleaos.databinding.ActivityMainBinding
import im.toss.cert.sdk.TossCertSession
import im.toss.cert.sdk.TossCertSessionGenerator
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.net.URLEncoder

class MainActivity : AppCompatActivity(), TossAuthInterface {
    private lateinit var binding: ActivityMainBinding
    private lateinit var tossOAuthApi: TossOAuthApi
    private lateinit var tossApi: TossApi

    private var authorization: String = ""
    private var txId: String = ""

    private var tossSessionGenerator = TossCertSessionGenerator()

    private val webViewClient = TossWebClient(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        initTossWebView()

        onBackPressedDispatcher.addCallback(onBackpressedCallback)

        tossOAuthApi = Retrofit.Builder()
            .baseUrl(AppConstants.TOSS_OAUTH_SERVER)
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .build().create(TossOAuthApi::class.java)

        tossApi = Retrofit.Builder()
            .baseUrl(AppConstants.TOSS_API_SERVER)
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .build().create(TossApi::class.java)

        requestAccessToken()
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun initTossWebView() {
        binding.webview.apply {
            addJavascriptInterface(this@MainActivity, "tossAuthWebView") // (1)
            settings.javaScriptEnabled = true
            webViewClient = this@MainActivity.webViewClient
        }
    }

    private fun loadTossAuthWeb(url: String, txId: String) {
        val postData = "txId=${URLEncoder.encode(txId, "UTF-8")}"
        binding.webview.postUrl(url, postData.toByteArray())
    }

    private fun requestAccessToken() {
        tossOAuthApi.requestAccessToken("client_credentials", AppConstants.TOSS_CLIENT_ID, AppConstants.TOSS_CLIENT_SECRET, "ca").enqueue(object:Callback<TossTokenRes> {
            override fun onResponse(call: Call<TossTokenRes>, response: Response<TossTokenRes>) {
                val res = response.body()

                if (res != null) {
                    authorization = "${res.tokenType} ${res.token}"
                    requestSignAuthInfo(authorization)
                }
            }

            override fun onFailure(call: Call<TossTokenRes>, t: Throwable) {

            }
        })
    }

    private fun requestSignAuthInfo(authorization: String) {
        val params = TossSignAuthReq("USER_NONE")
        tossApi.requestSignAuth(authorization, params).enqueue(object: Callback<TossApiRes<TossSignAuthInfo>> {
            override fun onResponse(call: Call<TossApiRes<TossSignAuthInfo>>, response: Response<TossApiRes<TossSignAuthInfo>>) {
                val res = response.body()
                val url = res?.success?.authUrl ?: ""
                txId = res?.success?.txId ?: ""

                if (url.isNotEmpty() && txId.isNotEmpty()) {
                    loadTossAuthWeb(url, txId)
                }
            }

            override fun onFailure(call: Call<TossApiRes<TossSignAuthInfo>>, t: Throwable) {}
        })
    }

    private fun requestSignAuthResult(authorization: String) {
        if (txId.isEmpty()) {
            return
        }

        val session = tossSessionGenerator.generate()
        val params = TossSignAuthResultReq(txId, session.sessionKey)
        tossApi.requestSignResult(authorization, params).enqueue(object: Callback<TossApiRes<TossSignAuthResult>> {
            override fun onResponse(call: Call<TossApiRes<TossSignAuthResult>>, response: Response<TossApiRes<TossSignAuthResult>>) {
                val res = response.body()?.success
                val personalData = res?.personalData

                if (personalData != null) {
                    testLogs(personalData, session)
                }
            }

            override fun onFailure(call: Call<TossApiRes<TossSignAuthResult>>, t: Throwable) { }
        })
    }

    private fun testLogs(personalData: TossPersonalData, session: TossCertSession) {
        val ciDecrypt = session.decrypt(personalData.ci)
        Log.i("toss test", "ci ::: $ciDecrypt")

        val builder = AlertDialog.Builder(this)
        builder.setMessage(ciDecrypt)
        builder.create().show()
    }

    @JavascriptInterface
    override fun sendMessage(message: String) {
        when (WindowMessages.valueOf(message)) {
            WindowMessages.TOSS_AUTH_POPUP_ONLOAD -> {
                /* 표준창 로딩 */
                Log.i("toss", "Loaded")
            }
            WindowMessages.TOSS_AUTH_SUCCESS -> {
                /* 인증 성공 */
                Log.i("toss", "Auth Success")
                requestSignAuthResult(authorization)
            }
            WindowMessages.TOSS_AUTH_FAIL -> {
                /* 인증 실패 */
                Log.i("toss", "Auth Fail")
            }
            WindowMessages.TOSS_AUTH_CLICK_NAVBAR_CLOSE -> {
                /* 표준창 닫기 */
                Log.i("toss", "Navbar close")
            }
        }
    }

    private val onBackpressedCallback = object : OnBackPressedCallback(true) {
        override fun handleOnBackPressed() {
            if (binding.webview.canGoBack()) {
                binding.webview.goBack()
            } else {
                finish()
            }
        }
    }
}