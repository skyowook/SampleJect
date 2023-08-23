package com.skw.tosssampleaos

import com.google.gson.annotations.SerializedName

/**
 * 토스 AccessToken
 */
data class TossTokenRes(
    @SerializedName("access_token")
    val token: String,

    val scope: String,

    @SerializedName("token_type")
    val tokenType: String,

    @SerializedName("expires_in")
    val expiresIn: Int
)

/**
 * 토스 API 통신 결과 기본 형태
 */
data class TossApiRes<RESULT>(
    val resultType: String,
    val success: RESULT?,
    val error: TossApiError?
)

/**
 * 토스 API 에러
 */
data class TossApiError (
    val errorType: Int,
    val errorCode: String,
    val reason: String
)

/**
 * 토스 본인인증 표준창 정보
 */
data class TossSignAuthInfo (
    val txId: String,
    val appScheme: String,
    val androidAppUri: String,
    val iosAppUri: String,
    val requestedDt: String,
    val authUrl: String
)

/**
 * 토스 본인인증 결과 유저 데이터 (암호화 된 값)
 *   - 요청 할 때 사용 했던 세션키(토스sdk)객체 활용해서 복호화 가능
 */
data class TossPersonalData(
    val ci: String,
    val name: String,
    val birthday: String,
    val gender: String,
    val nationality: String,
    val ci2: String?,
    val di: String,
    val ciUpdate: String?
)

data class TossSignAuthResult (
    val txId: String,
    val status: String,
    val userIdentifier: String?,
    val userCiToken: String?,
    val signature: String,
    val randomValue: String?,
    val completedDt: String,
    val requestedDt: String,
    val personalData: TossPersonalData?
)