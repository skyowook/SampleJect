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
import androidx.lifecycle.lifecycleScope
import com.google.gson.Gson
import com.skw.samplejectaos.databinding.ActivitySslTestBinding
import com.skw.samplejectaos.di.RetrofitApi
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.await
import retrofit2.converter.gson.GsonConverterFactory
import java.io.BufferedInputStream
import java.io.ByteArrayInputStream
import java.io.InputStream
import java.lang.Exception
import java.security.KeyStore
import java.security.KeyStoreException
import java.security.NoSuchAlgorithmException
import java.security.cert.CertificateException
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.X509TrustManager

@AndroidEntryPoint
class SSLTestActivity: AppCompatActivity() {
    companion object {
        const val TEST_URL = "https://dev-smart.kisb.co.kr"
//        const val TEST_URL = "https://m.naver.com"

        // FIXME
        private val elData = """
            {
              "elData": {
                "REQ_DATA": {
                  "OS": "ANDROID"
                }
              }
            }
             """.trimIndent()
        private val versionRequestParams: RequestBody
            get() {
                return elData.toRequestBody()
            }
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

//        webView.loadUrl(TEST_URL)
    }

    override fun onResume() {
        super.onResume()

        lifecycleScope.launch {
            try {
                val test = createRetrofitApi()?.getAppVersion(versionRequestParams)?.await()
                Log.d("test", Gson().toJson(test))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
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
MIIGnjCCBYagAwIBAgIMB5U3zk49lNXWijOHMA0GCSqGSIb3DQEBCwUAMFAxCzAJ
BgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSYwJAYDVQQDEx1H
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
-----BEGIN CERTIFICATE-----
MIIETjCCAzagAwIBAgINAe5fFp3/lzUrZGXWajANBgkqhkiG9w0BAQsFADBXMQsw
CQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEQMA4GA1UECxMH
Um9vdCBDQTEbMBkGA1UEAxMSR2xvYmFsU2lnbiBSb290IENBMB4XDTE4MDkxOTAw
MDAwMFoXDTI4MDEyODEyMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290
IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNp
Z24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2
hMoonv0FdhHFrYhy/EYCQ8eyip0EXyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9
DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+JJ5U4nwbXPsnLJlkNc96wyOkm
DoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8unPvQu7/1PQDh
BjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZp
hYIXAgMBAAGjggEiMIIBHjAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB
/zAdBgNVHQ4EFgQUj/BLf6guRSSuTVD6Y5qL3uLdG7wwHwYDVR0jBBgwFoAUYHtm
GkUNl8qJUC99BM00qP/8/UswPQYIKwYBBQUHAQEEMTAvMC0GCCsGAQUFBzABhiFo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9yb290cjEwMwYDVR0fBCwwKjAooCag
JIYiaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LmNybDBHBgNVHSAEQDA+
MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5j
b20vcmVwb3NpdG9yeS8wDQYJKoZIhvcNAQELBQADggEBACNw6c/ivvVZrpRCb8RD
M6rNPzq5ZBfyYgZLSPFAiAYXof6r0V88xjPy847dHx0+zBpgmYILrMf8fpqHKqV9
D6ZX7qw7aoXW3r1AY/itpsiIsBL89kHfDwmXHjjqU5++BfQ+6tOfUBJ2vgmLwgtI
fR4uUfaNU9OrH0Abio7tfftPeVZwXwzTjhuzp3ANNyuXlava4BJrHEDOxcd+7cJi
WOx37XMiwor1hkOIreoTbv3Y/kIvuX1erRjvlJDKPSerJpSZdcfL03v3ykzTr1Eh
kluEfSufFT90y1HonoMOFm8b50bOI7355KKL0jlrqnkckSziYSQtjipIcJDEHsXo
4HA=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDdTCCAl2gAwIBAgILBAAAAAABFUtaw5QwDQYJKoZIhvcNAQEFBQAwVzELMAkG
A1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNVBAsTB1Jv
b3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw05ODA5MDExMjAw
MDBaFw0yODAxMjgxMjAwMDBaMFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMRAwDgYDVQQLEwdSb290IENBMRswGQYDVQQDExJHbG9iYWxT
aWduIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDaDuaZ
jc6j40+Kfvvxi4Mla+pIH/EqsLmVEQS98GPR4mdmzxzdzxtIK+6NiY6arymAZavp
xy0Sy6scTHAHoT0KMM0VjU/43dSMUBUc71DuxC73/OlS8pF94G3VNTCOXkNz8kHp
1Wrjsok6Vjk4bwY8iGlbKk3Fp1S4bInMm/k8yuX9ifUSPJJ4ltbcdG6TRGHRjcdG
snUOhugZitVtbNV4FpWi6cgKOOvyJBNPc1STE4U6G7weNLWLBYy5d4ux2x8gkasJ
U26Qzns3dLlwR5EiUWMWea6xrkEmCMgZK9FGqkjWZCrXgzT/LCrBbBlDSgeF59N8
9iFo7+ryUp9/k5DPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBRge2YaRQ2XyolQL30EzTSo//z9SzANBgkqhkiG9w0B
AQUFAAOCAQEA1nPnfE920I2/7LqivjTFKDK1fPxsnCwrvQmeU79rXqoRSLblCKOz
yj1hTdNGCbM+w6DjY1Ub8rrvrTnhQ7k4o+YviiY776BQVvnGCv04zcQLcFGUl5gE
38NflNUVyRRBnMRddWQVDf9VMOyGj/8N7yy5Y0b2qvzfvGn9LhJIZJrglfCm7ymP
AbEVtQwdpf5pLGkkeB6zpxxxYu7KyJesF12KwvhHhm4qxFYxldBniYUr+WymXUad
DKqC5JlR3XC321Y9YeRq4VzW9v493kHMB65jUr9TU/Qr6cf9tveCX4XSQRjbgbME
HMUfpIBvFSDJ3gyICh3WZlXi/EjJKSZp4A==
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



    fun createRetrofitApi(): RetrofitApi? {
        val tmfactory = test()
        // Create an SSLContext that uses our TrustManager
        val context: SSLContext = SSLContext.getInstance("TLS").apply {
            init(null, tmfactory.trustManagers, null)
        }

        // 이걸써서 API 통신 모듈 (Retrofit)에 주면 인증서 전달가능.
        for (manager in tmfactory.trustManagers) {
            if (manager is X509TrustManager) {
                val okHttpClientBuilder: OkHttpClient.Builder = OkHttpClient.Builder()
                    .sslSocketFactory(context.socketFactory, manager)
                    .callTimeout(30, TimeUnit.SECONDS)
                    .connectTimeout(30, TimeUnit.SECONDS)

                return Retrofit.Builder()
                    .addConverterFactory(GsonConverterFactory.create(Gson()))
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .baseUrl("https://dev-smart.kisb.co.kr")
                    .client(okHttpClientBuilder.build())
                    .build()
                    .create(RetrofitApi::class.java)
            }
        }

        return null
    }

    private fun test(): TrustManagerFactory {
        val pem = """
-----BEGIN CERTIFICATE-----
MIIGojCCBYqgAwIBAgIMQcPy/zL8NBSfLTBmMA0GCSqGSIb3DQEBCwUAMFAxCzAJ
BgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSYwJAYDVQQDEx1H
bG9iYWxTaWduIFJTQSBPViBTU0wgQ0EgMjAxODAeFw0yMjA4MDUwODI2MDhaFw0y
MzA5MDYwODI2MDdaMHgxCzAJBgNVBAYTAktSMRQwEgYDVQQIEwtHeWVvbmdnaS1k
bzEUMBIGA1UEBxMLU2VvbmduYW0tc2kxJjAkBgNVBAoTHUtvcmVhIEludmVzdG1l
bnQgU2F2aW5ncyBCYW5rMRUwEwYDVQQDDAwqLmtpc2IuY28ua3IwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC92Bpequp92En7t5JUtgoMHFEYZqGZg8+2
oM1L9oUtrpG548XMx6rwSZDCJCLRbGfHvNn9sNqqb3jjyfjrh38IjqWzpE+ttD1F
8OFH7XTj8LCnLnHpgMQ1RwSMC5GUdtzJLTKnUiDg9qx8qsxpX7CF3YcKxyzStrIC
XaklkYD1qG1QdCp54UoOW1PO80k4npB0Gy8uie2HPWI+qcbVZSLBAct3DFpbsEAD
Q2idwQFWm7YJIfraF8QsSaYA5C6xS2daEREbdLfyAt0eWI8kpfqs22m1rxHNfjBC
dW8y58/xLwwyTgEXrh699lj8s8zJbWN1xQUqg0vlhA34FYFVLu4/AgMBAAGjggNS
MIIDTjAOBgNVHQ8BAf8EBAMCBaAwgY4GCCsGAQUFBwEBBIGBMH8wRAYIKwYBBQUH
MAKGOGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcnNhb3Zz
c2xjYTIwMTguY3J0MDcGCCsGAQUFBzABhitodHRwOi8vb2NzcC5nbG9iYWxzaWdu
LmNvbS9nc3JzYW92c3NsY2EyMDE4MFYGA1UdIARPME0wQQYJKwYBBAGgMgEUMDQw
MgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRv
cnkvMAgGBmeBDAECAjAJBgNVHRMEAjAAMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3Nyc2FvdnNzbGNhMjAxOC5jcmwwIwYDVR0R
BBwwGoIMKi5raXNiLmNvLmtyggpraXNiLmNvLmtyMB0GA1UdJQQWMBQGCCsGAQUF
BwMBBggrBgEFBQcDAjAfBgNVHSMEGDAWgBT473/yzXhnqN5vjySNiPGHAwKz6zAd
BgNVHQ4EFgQUg75onbyOajUWMxyMNsY+egITSvwwggGBBgorBgEEAdZ5AgQCBIIB
cQSCAW0BawB3AOg+0No+9QY1MudXKLyJa8kD08vREWvs62nhd31tBr1uAAABgm0c
paMAAAQDAEgwRgIhAJyVWfhINJ/kDMYbXWak6p9fmBseS0zsjLhCJQkvlnZ4AiEA
oo1VdWEVj+5CV/5inOXh+ORiGKW2Gbv5SrEkoocTcj0AdwA1zxkbv7FsV78PrUxt
Qsu7ticgJlHqP+Eq76gDwzvWTAAAAYJtHKWiAAAEAwBIMEYCIQDgOagX5p4eb9oY
3nB5AVO7XLEpeWK9nRZRfqQTJDYr9gIhAIFS9nlzoF0MiGyUvw4h8kTNEoMT14eZ
fpp2mUfvABTpAHcAVYHUwhaQNgFK6gubVzxT8MDkOHhwJQgXL6OqHQcT0wwAAAGC
bRyltQAABAMASDBGAiEArLKgeFcWsmbXq+TILilHdIKxOqi+YXQbwEEWHwTumIUC
IQD8U9Q5pSStQa7x/3JZLNQBr7V9D30wZFGfPYY18us7vDANBgkqhkiG9w0BAQsF
AAOCAQEAfmlGrDq9sO1Na1MBzwl0TzXfpvYDWCTJEs8EeTCdXEVgf29UR/UY92zP
q+WksQWB8VxAcF2Eo3bPqeYnS/1lahyn44o7ifiMTg2LxhWpJX1eZLvHwzGSlN+G
JyhLSxNbA2lskTB1M9E/UUYppsy3X9y4EGI8/7uDCasO1OYecRu9z7zzvmSGIOzY
GUOaoZBMDFOBnSAgMTCxO34BJpxtWhyGKRqoYwmEcsHGR+iWfQh1N7Im1Ldv1LZ8
VmLtMG1C2P35HHzVmRfTGIXTafCWyYnT1iwYNdKneL5dXFgzHLApWW4trjUC39Tu
UrG2geUaLKFIZP1GP50dHaIFKnVt3g==
-----END CERTIFICATE-----
    """.trimIndent()

        val cf: CertificateFactory = CertificateFactory.getInstance("X.509")
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

        return tmf
    }
}