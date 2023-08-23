package com.skw.tosssampleaos

import android.webkit.JavascriptInterface

enum class WindowMessages {
    TOSS_AUTH_POPUP_ONLOAD,
    TOSS_AUTH_SUCCESS,
    TOSS_AUTH_FAIL,
    TOSS_AUTH_CLICK_NAVBAR_CLOSE
}

interface TossAuthInterface {
    @JavascriptInterface
    fun sendMessage(message: String)
}