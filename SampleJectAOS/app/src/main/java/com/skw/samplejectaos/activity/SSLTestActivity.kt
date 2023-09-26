package com.skw.samplejectaos.activity

import android.annotation.SuppressLint
import android.content.SharedPreferences
import android.net.http.SslCertificate
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.webkit.ClientCertRequest
import android.webkit.SslErrorHandler
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.skw.samplejectaos.databinding.ActivitySslTestBinding
import java.io.BufferedInputStream
import java.io.ByteArrayInputStream
import java.io.InputStream
import java.security.KeyStore
import java.security.KeyStoreException
import java.security.NoSuchAlgorithmException
import java.security.cert.CertificateException
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.X509TrustManager

class SSLTestActivity: AppCompatActivity() {
    companion object {
        const val TEST_URL = "https://dev-smart.kisb.co.kr"
//        const val TEST_URL = "https://m.naver.com"
    }

    private lateinit var webView: WebView
    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)



        val bind = ActivitySslTestBinding.inflate(layoutInflater)
        setContentView(bind.root)

        webView = bind.webview

        webView.apply {
            webViewClient = TestClient()
            settings.javaScriptEnabled = true
            clearSslPreferences()
        }

        webView.loadUrl(TEST_URL)
    }

    class TestClient: WebViewClient() {
        override fun onReceivedSslError(view: WebView?, handler: SslErrorHandler?, error: SslError?) {
            if (error?.hasError(SslError.SSL_UNTRUSTED) == true) {
                Log.i("test", "SSL_UNTRUSTED")
            } else if (error?.hasError(SslError.SSL_EXPIRED) == true) {
                Log.i("test", "SSL_EXPIRED")
            } else if (error?.hasError(SslError.SSL_IDMISMATCH) == true) {
                Log.i("test", "SSL_IDMISMATCH")
            } else if (error?.hasError(SslError.SSL_INVALID) == true) {
                Log.i("test", "SSL_INVALID")
            } else if (error?.hasError(SslError.SSL_DATE_INVALID) == true) {
                Log.i("test", "SSL_DATE_INVALID")
            } else if (error?.hasError(SslError.SSL_NOTYETVALID) == true) {
                Log.i("test", "SSL_NOTYETVALID")
            }

//            if (error?.hasError(SslError.SSL_UNTRUSTED) == true) {
//
//            } else {
//                handler?.cancel()
//            }
            try {
                val cert: Array<X509Certificate?> = arrayOfNulls(1)
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                    // for andoid sdk < version 29, the SslCertificate does not
                    // contain a public method for getting the x509Certificate. The
                    // following code is the trick used to get the x509Certificate
                    // from the SslCertificate
                    val bundle = SslCertificate.saveState(error!!.certificate)
                    val bytes = bundle.getByteArray("x509-certificate")
                    if (bytes == null) {
                    } else {
                        try {
                            val certFactory = CertificateFactory.getInstance("X.509")
                            cert[0] =
                                certFactory.generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
                        } catch (e: CertificateException) {
                            cert[0] = null
                        }
                    }
                } else {
                    // for andoid sdk >= version 29, the SslCertificate contains
                    // a method for getting the x509Certificate
                    cert[0] = error!!.certificate.x509Certificate
                }
                if (cert[0] != null) {
                    val tmfactory = test()
                    val trustManager = tmfactory.trustManagers.first()
                    if (trustManager is X509TrustManager) {
                        trustManager.checkServerTrusted(cert, "RSA")
                        // Exception이 발생하지 않으면 성공으로 처리?? 위험성은?
                        handler?.proceed()
                    }
                }
            } catch (e: NoSuchAlgorithmException) {
                handler?.cancel()
            } catch (e: KeyStoreException) {
                handler?.cancel()
            } catch (e: CertificateException) {
                handler?.cancel()
            }
        }

        override fun onReceivedClientCertRequest(view: WebView?, request: ClientCertRequest?) {
            super.onReceivedClientCertRequest(view, request)

            Log.i("test", "Client CERT Request")
        }

        private fun test(): TrustManagerFactory {
            val pem = """
        -----BEGIN CERTIFICATE-----
        BgNVBAYTAkagAwIBAgIMB5U3zk49lNXWijOHMA0GCSqGSIb3DQEBCwUAMFAxCzAJ
        MIIGnjCCBYJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSYwJAYDVQQDEx1H
        bG9iYWxTaWduIFJTQSBPViBTU0wgQ0EgMjAxODAeFw0yMzA4MTgwNzMzNTBaFw0y
        NDA5MTgwNzMzNDlaMHgxCzAJBgNVBAYTAktSMRQwEgYDVQQIEwtHeWVvbmdnaS1k
        bzEUMBIGA1UEBxMLU2VvbmduYW0tc2kxJjAkBgNVBAoTHUtvcmVhIEludmVzdG1l
        bnQgU2F2aW5ncyBCYW5rMRUwEwYDVQQDDAwqLmtpc2IuY28ua3IwggEiMA0GCSqG
        SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDiwS5/ctJfOjRrK8fH0+KSMmFmrpaRnsob
        vzLgdBlQxN0RrMXAnHmGuGCGx/yo/eVMW3yzOoVwu46ZGixEEChqQb/zULn+BUjg
        N2WHRRQH39Xf9IM6jvQCDf62BTejR/Oi5arT75wckpY3tsO61YOjPuy4Y2lKB5zv
        kl5aQiMc0COqymbQBWCLEUyDvzBbiZghGnyfJp99QjD/MKoqL7nPWdj/hXqM9guz
        7ZOOwDTb35oReW3fwerZw4EDUhngsAEtiFJDAGyHLBmTjqiUa1ldRwZJQgHN7hkd
        Z26xciWGT4NWZnCbDeiEQ7rxRpJ4RCAVvIRMuVAzyGcjcxhviY2fAgMBAAGjggNO
        MIIDSjAOBgNVHQ8BAf8EBAMCBaAwgY4GCCsGAQUFBwEBBIGBMH8wRAYIKwYBBQUH
        MAKGOGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcnNhb3Zz
        c2xjYTIwMTguY3J0MDcGCCsGAQUFBzABhitodHRwOi8vb2NzcC5nbG9iYWxzaWdu
        LmNvbS9nc3JzYW92c3NsY2EyMDE4MFYGA1UdIARPME0wQQYJKwYBBAGgMgEUMDQw
        MgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRv
        cnkvMAgGBmeBDAECAjAJBgNVHRMEAjAAMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
        Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3Nyc2FvdnNzbGNhMjAxOC5jcmwwIwYDVR0R
        BBwwGoIMKi5raXNiLmNvLmtyggpraXNiLmNvLmtyMB0GA1UdJQQWMBQGCCsGAQUF
        BwMBBggrBgEFBQcDAjAfBgNVHSMEGDAWgBT473/yzXhnqN5vjySNiPGHAwKz6zAd
        BgNVHQ4EFgQUOezKXABSkzak+aL+qgiyNXjpP9AwggF9BgorBgEEAdZ5AgQCBIIB
        bQSCAWkBZwB1AO7N0GTV2xrOxVy3nbTNE6Iyh0Z8vOzew1FIWUZxH7WbAAABigeQ
        nW4AAAQDAEYwRAIgFbHXuHz/UCWHyQFAnw7x8JvxKjXBRSwdQn4cql5GRukCIHZr
        I8LlS5lFZynLZ967AjyacjqdcWU3NWQxotTX7++bAHUASLDja9qmRzQP5WoC+p0w
        6xxSActW3SyB2bu/qznYhHMAAAGKB5CaTQAABAMARjBEAiBAWEAQM8kDLLIWhGCE
        T7me7765a51HG8ZNpss5a2KgtgIgDKvPWOmfw0YH+3Jq35ODflZ26mOlnFUA/OdU
        C0nHM0cAdwDatr9rP7W2Ip+bwrtca+hwkXFsu1GEhTS9pD0wSNf7qwAAAYoHkJzG
        AAAEAwBIMEYCIQC+R3NUizyjpcZii4okIn6v36kqNd99wmqHwbvKf5pf8gIhALmm
        CyEdnz1Ne6quWxlFfknBbni7pok4OjZqhx75hpqPMA0GCSqGSIb3DQEBCwUAA4IB
        AQCXPQ26bsJx+lTt1Lo75O/TuqpdEZs02mzL8bDf/kWe165A8WJX7saWR6Iourmn
        IeY3RVBdpb36+pm8Iqg7J1lcar6ZRQgD2Ma5j2rPWKDAVQYGm8IxnzL6WyL/azXg
        v96Ub+edMwOzWrrlyeQhdbqFoSBe0nX840EsSIZas4qYXHyMm2cVSQSv3INDfjwy
        nTsTZC5RbFo0qS4aYD9UTCOCVVBMtxR1lB5z6LgYxiHxxx6lUl56sii3viifMXe0
        6hVKQ3QHJCnsFJuvrcH1dJpk1QsJFaFOn1I71sAl8H6uk6XPrkVSQ4nDlH7ZAkhm
        Lsl/mEjGEb1ju4L7piWPkBxV
        -----END CERTIFICATE-----
        -----BEGIN CERTIFICATE-----
        MIIETjCCAzagAwIBAgINAe5fIh38YjvUMzqFVzANBgkqhkiG9w0BAQsFADBMMSAw
        HgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFs
        U2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjAeFw0xODExMjEwMDAwMDBaFw0yODEx
        MjEwMDAwMDBaMFAxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
        LXNhMSYwJAYDVQQDEx1HbG9iYWxTaWduIFJTQSBPViBTU0wgQ0EgMjAxODCCASIw
        DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKdaydUMGCEAI9WXD+uu3Vxoa2uP
        UGATeoHLl+6OimGUSyZ59gSnKvuk2la77qCk8HuKf1UfR5NhDW5xUTolJAgvjOH3
        idaSz6+zpz8w7bXfIa7+9UQX/dhj2S/TgVprX9NHsKzyqzskeU8fxy7quRU6fBhM
        abO1IFkJXinDY+YuRluqlJBJDrnw9UqhCS98NE3QvADFBlV5Bs6i0BDxSEPouVq1
        lVW9MdIbPYa+oewNEtssmSStR8JvA+Z6cLVwzM0nLKWMjsIYPJLJLnNvBhBWk0Cq
        o8VS++XFBdZpaFwGue5RieGKDkFNm5KQConpFmvv73W+eka440eKHRwup08CAwEA
        AaOCASkwggElMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0G
        A1UdDgQWBBT473/yzXhnqN5vjySNiPGHAwKz6zAfBgNVHSMEGDAWgBSP8Et/qC5F
        JK5NUPpjmove4t0bvDA+BggrBgEFBQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6
        Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9yb290cjMwNgYDVR0fBC8wLTAroCmgJ4Yl
        aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIzLmNybDBHBgNVHSAEQDA+
        MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5j
        b20vcmVwb3NpdG9yeS8wDQYJKoZIhvcNAQELBQADggEBAJmQyC1fQorUC2bbmANz
        EdSIhlIoU4r7rd/9c446ZwTbw1MUcBQJfMPg+NccmBqixD7b6QDjynCy8SIwIVbb
        0615XoFYC20UgDX1b10d65pHBf9ZjQCxQNqQmJYaumxtf4z1s4DfjGRzNpZ5eWl0
        6r/4ngGPoJVpjemEuunl1Ig423g7mNA2eymw0lIYkN5SQwCuaifIFJ6GlazhgDEw
        fpolu4usBCOmmQDo8dIm7A9+O4orkjgTHY+GzYZSR+Y0fFukAj6KYXwidlNalFMz
        hriSqHKvoflShx8xpfywgVcvzfTO3PYkz6fiNJBonf6q8amaEsybwMbDqKWwIX7e
        SPY=
        -----END CERTIFICATE-----
    """.trimIndent()

            val cf: CertificateFactory = CertificateFactory.getInstance("X.509")
            // From https://www.washington.edu/itconnect/security/ca/load-der.crt
            val caInput: InputStream = BufferedInputStream(pem.byteInputStream())
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
    }
}