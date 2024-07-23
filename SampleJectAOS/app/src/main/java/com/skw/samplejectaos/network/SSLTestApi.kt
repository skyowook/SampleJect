package com.skw.samplejectaos.network

import com.skw.samplejectaos.data.PemCertificateData
import com.skw.samplejectaos.data.RawAppVersion
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface SSLTestApi {
    @POST("/APP010000001.pwkjson")
    fun getAppVersion(
        @Body params: RequestBody
    ): Call<RawAppVersion>

    @POST("/certificate_test.json")
    fun getPemCertificate(): Call<PemCertificateData>
}