package com.skw.tosssampleaos.toss

import android.util.Base64
import java.nio.charset.Charset
import java.security.InvalidAlgorithmParameterException
import java.security.InvalidKeyException
import java.security.NoSuchAlgorithmException
import java.security.spec.AlgorithmParameterSpec
import javax.crypto.BadPaddingException
import javax.crypto.Cipher
import javax.crypto.IllegalBlockSizeException
import javax.crypto.NoSuchPaddingException
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec


class TossCertSession internal constructor(
    private val version: String,
    private val id: String,
    private val algorithm: TossCertSessionGenerator.AESAlgorithm,
    private val secretKey: String,
    private val iv: String,
    private val encryptedSessionKey: String
) {
    internal class AESCipher @JvmOverloads constructor(
        secretKey: String?,
        iv: String?,
        algorithm: TossCertSessionGenerator.AESAlgorithm = TossCertSessionGenerator.AESAlgorithm.AES_GCM
    ) {
        private val secretKey: SecretKeySpec
        private var ivSpec: AlgorithmParameterSpec? = null
        private val algorithm: TossCertSessionGenerator.AESAlgorithm

        private val charset = Charset.forName("UTF-8")

        init {
            this.secretKey = SecretKeySpec(Base64.decode(secretKey!!, Base64.NO_WRAP), "AES")

            ivSpec = if (algorithm === TossCertSessionGenerator.AESAlgorithm.AES_GCM) {
                GCMParameterSpec(16 * Byte.SIZE_BITS, Base64.decode(iv!!, Base64.NO_WRAP))
            } else {
                IvParameterSpec(Base64.decode(iv!!, Base64.NO_WRAP))
            }
            this.algorithm = algorithm
        }

        @Throws(
            NoSuchPaddingException::class,
            NoSuchAlgorithmException::class,
            InvalidAlgorithmParameterException::class,
            InvalidKeyException::class,
            IllegalBlockSizeException::class,
            BadPaddingException::class
        )
        fun encrypt(plainText: String): String {
            val cipher: Cipher = getCipher(Cipher.ENCRYPT_MODE)
            val cipherText: ByteArray = cipher.doFinal(plainText.toByteArray())
            return TossUtils.base64Encode(cipherText)
        }

        @Throws(
            NoSuchPaddingException::class,
            NoSuchAlgorithmException::class,
            InvalidAlgorithmParameterException::class,
            InvalidKeyException::class,
            IllegalBlockSizeException::class,
            BadPaddingException::class
        )
        fun decrypt(encryptedText: String?): String {
            val cipher: Cipher = getCipher(Cipher.DECRYPT_MODE)
            val cipherText: ByteArray = cipher.doFinal(Base64.decode(encryptedText!!, Base64.NO_WRAP))
            return String(cipherText, charset)
        }

        @Throws(
            NoSuchPaddingException::class,
            NoSuchAlgorithmException::class,
            InvalidAlgorithmParameterException::class,
            InvalidKeyException::class
        )
        private fun getCipher(opMode: Int): Cipher {
            val cipher: Cipher = Cipher.getInstance(algorithm.algorithmName)
            cipher.init(opMode, secretKey, ivSpec)
            if (algorithm === TossCertSessionGenerator.AESAlgorithm.AES_GCM) {
                cipher.updateAAD(secretKey.encoded)
            }
            return cipher
        }
    }

    private val aesCipher: AESCipher = AESCipher(secretKey, iv, algorithm)

    val sessionKey: String
        get() = addMeta(encryptedSessionKey)

    fun encrypt(plainText: String): String {
        return try {
            val encrypted: String = aesCipher.encrypt(plainText)
            val hash = calculateHash(plainText)
            addMeta(TossUtils.join(separator, arrayOf(encrypted, hash)))
        } catch (e: InvalidAlgorithmParameterException) {
            throw RuntimeException(e.cause)
        } catch (e: NoSuchPaddingException) {
            throw RuntimeException(e.cause)
        } catch (e: IllegalBlockSizeException) {
            throw RuntimeException(e.cause)
        } catch (e: NoSuchAlgorithmException) {
            throw RuntimeException(e.cause)
        } catch (e: BadPaddingException) {
            throw RuntimeException(e.cause)
        } catch (e: InvalidKeyException) {
            throw RuntimeException(e.cause)
        }
    }

    fun decrypt(encryptedText: String): String {
        return try {
            val items = encryptedText.split(separatorRegEx.toRegex())
            if (items.size < 3) {
                throw RuntimeException("암호 문자열 포맷이 다릅니다")
            }
            if (version != items[0]) {
                throw RuntimeException(
                    String.format(
                        "세션 키 버전이 다릅니다. 세션 키 버전: %s != 암호 문자열 버전: %s",
                        version, items[0]
                    )
                )
            }
            if (id != items[1]) {
                throw RuntimeException(
                    String.format(
                        "세션 키 id 이 다릅니다. 세션 키 버전: %s != 암호 문자열 id 버전: %s",
                        id, items[1]
                    )
                )
            }
            val plainText: String = aesCipher.decrypt(items[2])
            verify(plainText, items)
            plainText
        } catch (e: InvalidAlgorithmParameterException) {
            throw RuntimeException(e.cause)
        } catch (e: NoSuchPaddingException) {
            throw RuntimeException(e.cause)
        } catch (e: IllegalBlockSizeException) {
            throw RuntimeException(e.cause)
        } catch (e: NoSuchAlgorithmException) {
            throw RuntimeException(e.cause)
        } catch (e: BadPaddingException) {
            throw RuntimeException(e.cause)
        } catch (e: InvalidKeyException) {
            throw RuntimeException(e.cause)
        }
    }

    fun serializeSession(): String {
        return TossUtils.join(
            separator, arrayOf(
                version,
                id, algorithm.name,
                secretKey,
                iv
            )
        )
    }

    @Throws(NoSuchAlgorithmException::class, InvalidKeyException::class)
    private fun verify(plainText: String, items: List<String>) {
        if (algorithm === TossCertSessionGenerator.AESAlgorithm.AES_GCM) return
        val calculatedHash: String = TossUtils.HMAC.calculateHash(secretKey, plainText)
        if (items.size != 4 || calculatedHash != items[3]) {
            throw RuntimeException("AES_CBC 무결성 검증 실패")
        }
    }

    @Throws(NoSuchAlgorithmException::class, InvalidKeyException::class)
    private fun calculateHash(plainText: String): String {
        return if (algorithm === TossCertSessionGenerator.AESAlgorithm.AES_GCM) "" else TossUtils.HMAC.calculateHash(
            secretKey,
            plainText
        )
    }

    private fun addMeta(data: String): String {
        return TossUtils.join(
            separator, arrayOf(
                version,
                id, data
            )
        )
    }

    companion object {
        const val separator = "$"
        const val separatorRegEx = "\\$"
    }
}
