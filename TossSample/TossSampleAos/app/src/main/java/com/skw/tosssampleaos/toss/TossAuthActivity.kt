package com.skw.tosssampleaos.toss

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.webkit.JavascriptInterface
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.skw.tosssampleaos.databinding.ActivityTossAuthBinding
import com.skw.tosssampleaos.launchSafely
import dagger.hilt.android.AndroidEntryPoint
import im.toss.cert.sdk.TossCertSessionGenerator
import java.net.URLEncoder
import javax.inject.Inject

@AndroidEntryPoint
class TossAuthActivity : AppCompatActivity(), TossAuthInterface {
    @Inject lateinit var tossRepository: TossRepository
    private lateinit var binding: ActivityTossAuthBinding

    private var txId: String = ""

    private var tossSessionGenerator = TossCertSessionGenerator()

    private val webViewClient = TossWebClient(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityTossAuthBinding.inflate(layoutInflater)
        setContentView(binding.root)

        initTossWebView()

        onBackPressedDispatcher.addCallback(onBackpressedCallback)

        lifecycleScope.launchSafely(block = {
            val res = tossRepository.requestSignAuth()

            val url = res?.success?.authUrl ?: ""
            txId = res?.success?.txId ?: ""

            if (url.isNotEmpty() && txId.isNotEmpty()) {
                loadTossAuthWeb(url, txId)
            }
        }, handleException = {
            Log.i("test", it.message ?: "")
        })
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun initTossWebView() {
        binding.webview.apply {
            addJavascriptInterface(this@TossAuthActivity, "tossAuthWebView") // (1)
            settings.javaScriptEnabled = true
            webViewClient = this@TossAuthActivity.webViewClient
        }
    }

    private fun loadTossAuthWeb(url: String, txId: String) {
        val postData = "txId=${URLEncoder.encode(txId, "UTF-8")}"
        binding.webview.postUrl(url, postData.toByteArray())
    }

    private fun testLogs() {
        lifecycleScope.launchSafely(block = {
            val session = tossSessionGenerator.generate()
            val params = TossSignAuthResultReq(txId, session.sessionKey)
            val res = tossRepository.requestSignResult(params)
            val personalData = res?.success?.personalData

            if (personalData != null) {
                val ciDecrypt = session.decrypt(personalData.ci)
                Log.i("toss test", "ci ::: $ciDecrypt")

                val builder = AlertDialog.Builder(this@TossAuthActivity)
                builder.setMessage(ciDecrypt)
                builder.create().show()
            }
        }, handleException = {

        })
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
                testLogs()
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