package com.skw.tosssampleaos.toss

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.Header
import retrofit2.http.POST

/**
 * 토스 OAuth2 API
 */
interface TossOAuthApi {
    @POST("/token")
    @FormUrlEncoded
    fun requestAccessToken(
        @Field("grant_type") grantType: String,
        @Field("client_id") clientId: String,
        @Field("client_secret") clientSecret: String,
        @Field("scope") scope: String
    ): Call<TossTokenRes>
}

/**
 * 토스 API
 */
interface TossApi {
    @POST("/api/v2/sign/user/auth/id/request")
    fun requestSignAuth(
        @Header("Authorization") authorization: String,
        @Body body: TossSignAuthReq
    ): Call<TossApiRes<TossSignAuthInfo>>

    @POST("/api/v2/sign/user/auth/id/result")
    fun requestSignResult(
        @Header("Authorization") authorization: String,
        @Body body: TossSignAuthResultReq
    ): Call<TossApiRes<TossSignAuthResult>>
}