package com.skw.tosssampleaos.toss

import android.util.Base64
import java.nio.charset.Charset
import java.security.InvalidKeyException
import java.security.KeyFactory
import java.security.NoSuchAlgorithmException
import java.security.PublicKey
import java.security.SecureRandom
import java.security.spec.InvalidKeySpecException
import java.security.spec.X509EncodedKeySpec
import java.util.UUID
import javax.crypto.BadPaddingException
import javax.crypto.Cipher
import javax.crypto.IllegalBlockSizeException
import javax.crypto.KeyGenerator
import javax.crypto.NoSuchPaddingException

class TossCertSessionGenerator {
    internal object SecureKeyGenerator {
        private val secureRandom = SecureRandom()
        @Throws(NoSuchAlgorithmException::class)
        fun generateKey(aesKeyBitLength: Int): String {
            val keyGenerator: KeyGenerator = KeyGenerator.getInstance("AES")
            keyGenerator.init(aesKeyBitLength, secureRandom)
            return TossUtils.base64Encode(keyGenerator.generateKey().encoded)
        }

        fun generateRandomBytes(lengthInBits: Int): String {
            val bytes = ByteArray(lengthInBits / 8)
            secureRandom.nextBytes(bytes)
            return TossUtils.base64Encode(bytes)
        }
    }
    enum class AESAlgorithm(var algorithmName: String) {
        AES_CBC("AES/CBC/PKCS5Padding"), AES_GCM("AES/GCM/NoPadding")
    }

    private val version = "v1_0.0.11"
    private var publicKey: PublicKey? = null

    init {
        publicKey = getPublicKeyFromBase64Encrypted("MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAoVdxG0Qi9pip46Jw9ImSlPVD8+L2mM47ey6EZna7D7utgNdh8Tzkjrm1Yl4h6kPJrhdWvMIJGS51+6dh041IXcJEoUquNblUEqAUXBYwQM8PdfnS12SjlvZrP4q6whBE7IV1SEIBJP0gSK5/8Iu+uld2ctJiU4p8uswL2bCPGWdvVPltxAg6hfAG/ImRUKPRewQsFhkFvqIDCpO6aeaR10q6wwENZltlJeeRnl02VWSneRmPqqypqCxz0Y+yWCYtsA+ngfZmwRMaFkXcWjaWnvSqqV33OAsrQkvuBHWoEEkvQ0P08+h9Fy2+FhY9TeuukQ2CVFz5YyOhp25QtWyQI+IaDKk+hLxJ1APR0c3tmV0ANEIjO6HhJIdu2KQKtgFppvqSrZp2OKtI8EZgVbWuho50xvlaPGzWoMi9HSCb+8ARamlOpesxHH3O0cTRUnft2Zk1FHQb2Pidb2z5onMEnzP2xpTqAIVQyb6nMac9tof5NFxwR/c4pmci+1n8GFJIFN18j2XGad1mNyio/R8LabqnzNwJC6VPnZJz5/pDUIk9yKNOY0KJe64SRiL0a4SNMohtyj6QlA/3SGxaEXb8UHpophv4G9wN1CgfyUamsRqp8zo5qDxBvlaIlfkqJvYPkltj7/23FHDjPi8q8UkSiAeu7IV5FTfB5KsiN8+sGSMCAwEAAQ==")
    }

    private val charset = Charset.forName("UTF-8")
    fun generate(): TossCertSession {
        return generate(AESAlgorithm.AES_GCM)
    }

    fun generateCBC128(): TossCertSession {
        return generate(AESAlgorithm.AES_CBC, 128, 128)
    }

    private fun generate(algorithm: AESAlgorithm): TossCertSession {
        return if (algorithm === AESAlgorithm.AES_GCM) {
            generate(algorithm, 256, 96)
        } else {
            generate(algorithm, 256, 128)
        }
    }

    private fun generate(algorithm: AESAlgorithm, keyLength: Int, ivLength: Int): TossCertSession {
        return try {
            val id = UUID.randomUUID().toString()
            val secretKey: String = SecureKeyGenerator.generateKey(keyLength)
            val iv: String = if (algorithm === AESAlgorithm.AES_GCM) {
                SecureKeyGenerator.generateRandomBytes(ivLength)
            } else {
                SecureKeyGenerator.generateKey(ivLength)
            }
            val encryptedSessionKey = buildEncryptSessionKeyPart(algorithm, secretKey, iv)
            TossCertSession(version, id, algorithm, secretKey, iv, encryptedSessionKey)
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

    fun deserialize(serializedSessionKey: String): TossCertSession? {
        return try {
            val fields: Array<String> =
                serializedSessionKey.split(TossCertSession.separatorRegEx.toRegex())
                    .dropLastWhile { it.isEmpty() }
                    .toTypedArray()
            val algorithm: AESAlgorithm = AESAlgorithm.valueOf(fields[2])
            val secretKey = fields[3]
            val iv = fields[4]
            val encryptedSessionKey = buildEncryptSessionKeyPart(algorithm, secretKey, iv)
            TossCertSession(fields[0], fields[1], algorithm, secretKey, iv, encryptedSessionKey)
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

    @Throws(NoSuchPaddingException::class, IllegalBlockSizeException::class, NoSuchAlgorithmException::class, BadPaddingException::class, InvalidKeyException::class)
    private fun buildEncryptSessionKeyPart(
        algorithm: AESAlgorithm,
        secretKey: String,
        iv: String
    ): String {
        val part: String = TossUtils.join(
            TossCertSession.separator,
            arrayOf(algorithm.name, secretKey, iv)
        )
        return rsaEncrypt(part)
    }

    @Throws(NoSuchAlgorithmException::class, InvalidKeySpecException::class)
    private fun getPublicKeyFromBase64Encrypted(base64PublicKey: String): PublicKey {
        val decodedBase64PubKey = Base64.decode(base64PublicKey, Base64.NO_WRAP)
        return KeyFactory.getInstance("RSA").generatePublic(X509EncodedKeySpec(decodedBase64PubKey))
    }

    @Throws(NoSuchPaddingException::class, NoSuchAlgorithmException::class, InvalidKeyException::class, BadPaddingException::class, IllegalBlockSizeException::class)
    fun rsaEncrypt(plainText: String): String {
        val cipher: Cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-1AndMGF1Padding")
        cipher.init(Cipher.ENCRYPT_MODE, publicKey)
        val bytePlain: ByteArray = cipher.doFinal(plainText.toByteArray(charset))
        return TossUtils.base64Encode(bytePlain)
    }
}