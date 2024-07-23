package com.skw.samplejectaos.data

import com.google.gson.annotations.SerializedName

data class PemCertificateData(
    var old: String,
    var new: String
)

data class RawAppVersion(

    @SerializedName("elData")
    val elData: RawElData,

    @SerializedName("elHeader")
    val elHeader: RawElHeader
)

data class RawElData(
    /**
     * 배포할 앱의 버전
     */
    @SerializedName("newAppVerCd")
    val newVersionCode: String,

    /**
     * 강제 배포 여부
     */
    @SerializedName("enfrcUpdYn")
    val enforceUpdate: String,

    /**
     * 배포 시작일
     */
    @SerializedName("aplcDtm")
    val releaseDate: String,

    /**
     * 사용 여부
     */
    @SerializedName("useYn")
    val use: String
)

data class RawElHeader(
    /**
     * API 성공 여부
     */
    @SerializedName("resSuc")
    val success: Boolean
)