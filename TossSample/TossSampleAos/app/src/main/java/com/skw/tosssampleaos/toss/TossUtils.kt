package com.skw.tosssampleaos.toss

import android.util.Base64
import java.nio.charset.Charset
import java.security.InvalidKeyException
import java.security.NoSuchAlgorithmException
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec


class TossUtils {
    companion object {
        fun join(separator: String?, dataList: Array<String>?): String {
            if (dataList == null) return ""
            if (dataList.isEmpty()) return ""
            if (dataList.size == 1) return dataList[0]
            val builder = StringBuilder()
            builder.append(dataList[0])
            for (i in 1 until dataList.size) {
                if (dataList[i].isEmpty()) continue
                builder.append(separator)
                builder.append(dataList[i])
            }
            return builder.toString()
        }

        fun base64Encode(data: ByteArray): String {
            return Base64.encodeToString(data, Base64.NO_WRAP).trim().replace("\n", "")
        }
    }
    internal object HMAC {
        private const val algorithm = "HmacSHA256"
        private val charset = Charset.forName("UTF-8")

        @Throws(NoSuchAlgorithmException::class, InvalidKeyException::class)
        fun calculateHash(secret: String, message: String): String {
            val sha256Hmac: Mac = Mac.getInstance(algorithm)
            val secretKey = SecretKeySpec(secret.toByteArray(charset), algorithm)
            sha256Hmac.init(secretKey)
            return bytesToHex(sha256Hmac.doFinal(message.toByteArray(charset)))
        }

        private val HEX_ARRAY = "0123456789abcdef".toCharArray()
        private fun bytesToHex(bytes: ByteArray): String {
            val hexChars = CharArray(bytes.size * 2)
            for (j in bytes.indices) {
                val v = bytes[j].toInt() and 0xFF
                hexChars[j * 2] = HEX_ARRAY[v ushr 4]
                hexChars[j * 2 + 1] = HEX_ARRAY[v and 0x0F]
            }
            return String(hexChars)
        }
    }
}