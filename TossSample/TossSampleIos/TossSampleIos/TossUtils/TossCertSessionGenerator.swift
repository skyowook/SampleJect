//
//  TossCertSessionGenerator.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation

/// 토스 CertSession 생성기
class TossCertSessionGenerator {
    private let version = "v1_0.0.11"
    private let publicKey: String = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAoVdxG0Qi9pip46Jw9ImSlPVD8+L2mM47ey6EZna7D7utgNdh8Tzkjrm1Yl4h6kPJrhdWvMIJGS51+6dh041IXcJEoUquNblUEqAUXBYwQM8PdfnS12SjlvZrP4q6whBE7IV1SEIBJP0gSK5/8Iu+uld2ctJiU4p8uswL2bCPGWdvVPltxAg6hfAG/ImRUKPRewQsFhkFvqIDCpO6aeaR10q6wwENZltlJeeRnl02VWSneRmPqqypqCxz0Y+yWCYtsA+ngfZmwRMaFkXcWjaWnvSqqV33OAsrQkvuBHWoEEkvQ0P08+h9Fy2+FhY9TeuukQ2CVFz5YyOhp25QtWyQI+IaDKk+hLxJ1APR0c3tmV0ANEIjO6HhJIdu2KQKtgFppvqSrZp2OKtI8EZgVbWuho50xvlaPGzWoMi9HSCb+8ARamlOpesxHH3O0cTRUnft2Zk1FHQb2Pidb2z5onMEnzP2xpTqAIVQyb6nMac9tof5NFxwR/c4pmci+1n8GFJIFN18j2XGad1mNyio/R8LabqnzNwJC6VPnZJz5/pDUIk9yKNOY0KJe64SRiL0a4SNMohtyj6QlA/3SGxaEXb8UHpophv4G9wN1CgfyUamsRqp8zo5qDxBvlaIlfkqJvYPkltj7/23FHDjPi8q8UkSiAeu7IV5FTfB5KsiN8+sGSMCAwEAAQ=="
    
    // MARK: - Class Func
    class func encrypt(_ string: String, _ publicKey: Data?) -> String? {
        guard let data = publicKey else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic] as CFDictionary
        }

        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            print(error.debugDescription)
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }

    private class func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = Array(string.utf8)
        let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
        return (SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA1, Data(buffer) as CFData, error) as? Data)?.base64EncodedString()
    }
    
    // MARK: - Public Func
    func generate() -> TossCertSession {
        return generate(.AES_GCM, 256, 96)
    }

    // MARK: - Private Func
    private func generate(_ algorithm: AESAlgorithm, _ keyLength: Int, _ ivLength: Int) -> TossCertSession {
        let id = (CFUUIDCreateString(nil, CFUUIDCreate(nil))! as String).lowercased()
        let secretKey: String = SecureKeyGenerator.generateRandomBytes(keyLength)
        let iv: String = SecureKeyGenerator.generateRandomBytes(ivLength)
        let encryptedSessionKey = buildEncryptSessionKeyPart(algorithm, secretKey, iv)
        return TossCertSession(version, id, algorithm, secretKey, iv, encryptedSessionKey)
    }

    private func buildEncryptSessionKeyPart(_ algorithm: AESAlgorithm, _ secretKey: String, _ iv: String) -> String {
        let part: String = TossUtils.join(TossCertSession.SEPARATOR, [String(describing: algorithm), secretKey, iv])
        return TossCertSessionGenerator.encrypt(part, publicKey.base64Decode()) ?? ""
    }
}
