package com.skw.samplejectaos.common

import android.util.Log
import java.io.BufferedInputStream
import java.io.InputStream
import java.security.KeyStore
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManagerFactory

const val LogTAG = "test"

var blockTime: Long = 0

fun checkBlockTime(msg: String) {
    Log.i(LogTAG, "$msg ${System.currentTimeMillis() - blockTime}")
    blockTime = System.currentTimeMillis()
}

fun createTrustManager(pemString: String): TrustManagerFactory {
    val cf: CertificateFactory = CertificateFactory.getInstance("X.509")
    // From https://www.washington.edu/itconnect/security/ca/load-der.crt
    val caInput: InputStream = BufferedInputStream(pemString.trimIndent().byteInputStream())
    val ca: X509Certificate = caInput.use {
        cf.generateCertificate(it) as X509Certificate
    }

    // Create a KeyStore containing our trusted CAs
    val keyStoreType = KeyStore.getDefaultType()
    val keyStore = KeyStore.getInstance(keyStoreType).apply {
        load(null, null)
        setCertificateEntry("ca", ca)
    }

    // Create a TrustManager that trusts the CAs inputStream our KeyStore
    val tmfAlgorithm: String = TrustManagerFactory.getDefaultAlgorithm()
    val tmf: TrustManagerFactory = TrustManagerFactory.getInstance(tmfAlgorithm).apply {
        init(keyStore)
    }

    // Create an SSLContext that uses our TrustManager
    val context: SSLContext = SSLContext.getInstance("TLS").apply {
        init(null, tmf.trustManagers, null)
    }

    // 이걸써서 API 통신 모듈 (Retrofit)에 주면 인증서 전달가능.
    // context.socketFactory
    return tmf
}