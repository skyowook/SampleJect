package com.skw.tosssampleaos

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient

class TossWebClient(private val context: Context): WebViewClient() {
    companion object {
        const val TOSS_INTENT = "intent"
        const val TOSS_MARKET = "market"
    }
    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
        return when (request?.url?.scheme) {
            TOSS_INTENT -> {
                val schemeIntent = Intent.parseUri(request.url.toString(), Intent.URI_INTENT_SCHEME)
                try {
                    context.startActivity(schemeIntent)
                } catch (e: ActivityNotFoundException) {
                    val marketIntent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=${schemeIntent.`package`}"))
                    context.startActivity(marketIntent)
                }
                true
            }
            TOSS_MARKET -> {
                val marketIntent = Intent(Intent.ACTION_VIEW, Uri.parse(request.url.toString()))
                context.startActivity(marketIntent)
                true
            }
            else -> false
        }
    }
}