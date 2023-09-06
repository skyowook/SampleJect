//
//  TossCertSessionGenerator.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation
import CryptoSwift

class TossCertSessionGenerator {
    private let version = "v1_0.0.11"
    private var publicKey: String = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAoVdxG0Qi9pip46Jw9ImSlPVD8+L2mM47ey6EZna7D7utgNdh8Tzkjrm1Yl4h6kPJrhdWvMIJGS51+6dh041IXcJEoUquNblUEqAUXBYwQM8PdfnS12SjlvZrP4q6whBE7IV1SEIBJP0gSK5/8Iu+uld2ctJiU4p8uswL2bCPGWdvVPltxAg6hfAG/ImRUKPRewQsFhkFvqIDCpO6aeaR10q6wwENZltlJeeRnl02VWSneRmPqqypqCxz0Y+yWCYtsA+ngfZmwRMaFkXcWjaWnvSqqV33OAsrQkvuBHWoEEkvQ0P08+h9Fy2+FhY9TeuukQ2CVFz5YyOhp25QtWyQI+IaDKk+hLxJ1APR0c3tmV0ANEIjO6HhJIdu2KQKtgFppvqSrZp2OKtI8EZgVbWuho50xvlaPGzWoMi9HSCb+8ARamlOpesxHH3O0cTRUnft2Zk1FHQb2Pidb2z5onMEnzP2xpTqAIVQyb6nMac9tof5NFxwR/c4pmci+1n8GFJIFN18j2XGad1mNyio/R8LabqnzNwJC6VPnZJz5/pDUIk9yKNOY0KJe64SRiL0a4SNMohtyj6QlA/3SGxaEXb8UHpophv4G9wN1CgfyUamsRqp8zo5qDxBvlaIlfkqJvYPkltj7/23FHDjPi8q8UkSiAeu7IV5FTfB5KsiN8+sGSMCAwEAAQ=="

    init() {

    }

    func generate() -> TossCertSession {
        return generate(.aes_gcm)
    }

    func generateCBC128() -> TossCertSession {
        return generate(.aes_cbc, 128, 128)
    }

    private func generate(_ algorithm: AESAlgorithm) -> TossCertSession {
        if (algorithm == .aes_gcm) {
            return generate(algorithm, 256, 96)
        } else {
            return generate(algorithm, 256, 128)
        }
    }

    private func generate(_ algorithm: AESAlgorithm, _ keyLength: Int, _ ivLength: Int) -> TossCertSession {
        let id = CFUUIDCreateString(nil, CFUUIDCreate(nil))! as String
        let secretKey: String = SecureKeyGenerator.generateKey(keyLength)
        let iv: String
        if algorithm == .aes_gcm {
            iv = SecureKeyGenerator.generateRandomBytes(ivLength)
        } else {
            iv = SecureKeyGenerator.generateKey(ivLength)
        }
        let encryptedSessionKey = buildEncryptSessionKeyPart(algorithm, secretKey, iv)
        return TossCertSession(version, id, algorithm, secretKey, iv, encryptedSessionKey)
    }

    private func buildEncryptSessionKeyPart(_ algorithm: AESAlgorithm, _ secretKey: String, _ iv: String) -> String {
        let part: String = TossUtils.join(TossCertSession.SEPARATOR, [algorithm.rawValue, secretKey, iv])
        return rsaEncrypt(part)
//        return TossCertSessionGenerator.encrypt(part, publicKey) ?? ""
    }

    private func getPublicKeyFromBase64Encrypted(_ base64PublicKey: String) -> Data {
        return base64PublicKey.base64Decode()!
    }

    func rsaEncrypt(_ plainText: String) -> String {
//        let cipher = try? RSA(rawRepresentation: publicKey!)
//        if let bytes = try? cipher?.encrypt(plainText.bytes) {
//            return Data(bytes).base64EncodedString()
//        }
        return ""
    }
    
    static func encrypt(_ string: String, _ publicKey: String) -> String? {
        guard let data = publicKey.base64Decode() else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrSecurityDomain  : kSecPolicyAppleX509Basic,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic] as CFDictionary
        }

        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            print(error.debugDescription)
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }

    static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = Array(string.utf8)

        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = Array(repeating: 0, count: keySize)
        let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
        // Encrypto  should less than key length
        
        return (SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, Data(buffer) as! CFData, error) as! Data).base64EncodedString()
//        guard SecKeyEncrypt(publicKey, .OAEP, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
//        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
