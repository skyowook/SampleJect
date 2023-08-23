package com.skw.tosssampleaos

import com.google.gson.annotations.SerializedName

/**
 * 토스 본인인증 표준창 정보 요청 필드
 */
data class TossSignAuthReq(
    val requestType: String
)

/**
 * 토스 본인인증 결과 요청 필드
 */
data class TossSignAuthResultReq(
    val txId: String,
    val sessionKey: String
)