package com.skw.tosssampleaos.toss

import android.content.Context
import com.google.gson.Gson
import com.skw.tosssampleaos.AppConstants
import com.skw.tosssampleaos.getSecurePref
import dagger.hilt.android.qualifiers.ApplicationContext
import retrofit2.await
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class TossRepository @Inject constructor(@ApplicationContext val context: Context) {
    companion object {
        const val KEY_TOSS_TOKEN_JSON = "key_toss_accesstoken_json"
        const val ERROR_TOKEN = "CE1000"
    }

    @Inject lateinit var tossApi: TossApi
    @Inject lateinit var tossAuthApi: TossOAuthApi

    private val pref = getSecurePref(context)

    /**
     * 토큰 가져오기
     */
    private suspend fun requestAccessToken(): TossTokenRes {
        val scope = "ca"
        val grantType = "client_credentials"
        val res = tossAuthApi.requestAccessToken(grantType,
            AppConstants.TOSS_CLIENT_ID,
            AppConstants.TOSS_CLIENT_SECRET, scope).await()
        val jsonString = Gson().toJson(res)
        pref.edit().putString(KEY_TOSS_TOKEN_JSON, jsonString).apply()
        return res
    }

    /**
     * 본인인증 요청
     */
    suspend fun requestSignAuth(isRetry: Boolean = false): TossApiRes<TossSignAuthInfo>? {
        val authorization = getTossToken().getAuthorization()
        val params = TossSignAuthReq("USER_NONE")
        val res = tossApi.requestSignAuth(authorization, params).await()
        if (isTokenErrorCheck(res.error)) {
            return if (!isRetry) requestSignAuth(true) else null
        }

        return res
    }

    /**
     * 본인인증 결과 요청
     */
    suspend fun requestSignResult(params: TossSignAuthResultReq, isRetry: Boolean = false): TossApiRes<TossSignAuthResult>? {
        val authorization = getTossToken().getAuthorization()
        val res = tossApi.requestSignResult(authorization, params).await()
        if (isTokenErrorCheck(res.error)) {
            return if (!isRetry) requestSignResult(params, true) else null
        }

        return res
    }

    /**
     * 토큰 Expire 체크
     */
    private suspend fun isTokenErrorCheck(res: TossApiError?): Boolean {
        if (res?.errorCode == ERROR_TOKEN) {
            requestAccessToken()
            return true
        }

        return false
    }

    /**
     * 토큰 반환
     */
    private suspend fun getTossToken(): TossTokenRes {
        val jsonString = pref.getString(KEY_TOSS_TOKEN_JSON, null)
        return if (jsonString == null) {
            requestAccessToken()
        } else {
            Gson().fromJson(jsonString, TossTokenRes::class.java)
        }
    }
}