package com.skw.samplejectaos.web

import android.annotation.SuppressLint
import android.graphics.Color
import android.net.http.SslCertificate
import android.net.http.SslError
import android.os.Build
import android.util.Log
import android.webkit.ClientCertRequest
import android.webkit.SslErrorHandler
import android.webkit.WebView
import android.webkit.WebViewClient
import com.skw.samplejectaos.common.createTrustManager
import java.io.ByteArrayInputStream
import java.security.KeyStoreException
import java.security.NoSuchAlgorithmException
import java.security.cert.CertificateException
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager


class SSLTestWebViewClient: WebViewClient() {
    private lateinit var trustManager: TrustManager

    fun setPemString(string: String) {
        val tmf = createTrustManager(string)
        trustManager = tmf.trustManagers.first()
    }

    @SuppressLint("WebViewClientOnReceivedSslError")
    override fun onReceivedSslError(view: WebView?, handler: SslErrorHandler?, error: SslError?) {
        if (error?.hasError(SslError.SSL_UNTRUSTED) == true) {
            // 인증서 신뢰할 수 없음. 이공간에 체크 로직 필요. 검증 ok proceed, no cancel
            Log.i("test", "SSL_UNTRUSTED")
        } else if (error?.hasError(SslError.SSL_EXPIRED) == true) {
            Log.i("test", "SSL_EXPIRED")
            // 인증서 만료는 cancel
        } else if (error?.hasError(SslError.SSL_IDMISMATCH) == true) {
            // 도메인 없음. cancel
            Log.i("test", "SSL_IDMISMATCH")
        } else if (error?.hasError(SslError.SSL_INVALID) == true) {
            // 인증서가 올바르지 않음 cancel
            Log.i("test", "SSL_INVALID")
        } else if (error?.hasError(SslError.SSL_DATE_INVALID) == true) {

            Log.i("test", "SSL_DATE_INVALID")
        } else if (error?.hasError(SslError.SSL_NOTYETVALID) == true) {
            Log.i("test", "SSL_NOTYETVALID")
        }

//        if (error?.hasError(SslError.SSL_UNTRUSTED) == true) {
//            handler?.cancel()
//        } else {
//
//        }
        try {
            val cert: Array<X509Certificate?> = arrayOfNulls(1)
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                // for andoid sdk < version 29, the SslCertificate does not
                // contain a public method for getting the x509Certificate. The
                // following code is the trick used to get the x509Certificate
                // from the SslCertificate
                val bundle = SslCertificate.saveState(error!!.certificate)
                val bytes = bundle.getByteArray("x509-certificate")
                if (bytes != null) {
                    try {
                        val certFactory = CertificateFactory.getInstance("X.509")
                        cert[0] = certFactory.generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
                    } catch (e: CertificateException) {
                        cert[0] = null
                    }
                } else {
                    // bytes is null
                }
            } else {
                // for andoid sdk >= version 29, the SslCertificate contains
                // a method for getting the x509Certificate
                cert[0] = error!!.certificate.x509Certificate
            }

            if (cert[0] != null) {
                if (trustManager is X509TrustManager) {
                    (trustManager as X509TrustManager).checkServerTrusted(cert, "RSA")
                    // Exception이 발생하지 않으면 성공으로 처리?? 위험성은?
                    view?.setBackgroundColor(Color.WHITE)
                    // 한번 proceed하고 나면 onreceived가 더이상 호출되지 않음.
                    handler?.proceed()
                }
            }
        } catch (e: NoSuchAlgorithmException) {
            view?.loadUrl("about:blank")
            handler?.cancel()
        } catch (e: KeyStoreException) {
            view?.loadUrl("about:blank")
            handler?.cancel()
        } catch (e: CertificateException) {
            view?.loadUrl("about:blank")
            view?.setBackgroundColor(Color.BLUE)
            handler?.cancel()
        }
    }

    override fun onReceivedClientCertRequest(view: WebView?, request: ClientCertRequest?) {
        Log.i("test", "onReceivedClientCertRequest")
        super.onReceivedClientCertRequest(view, request)
    }
}