package com.skw.samplejectaos.di

import com.skw.samplejectaos.RawAppVersion
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface RetrofitApi {
    @POST("/APP010000001.pwkjson")
    fun getAppVersion(
        @Body params: RequestBody
    ): Call<RawAppVersion>
}