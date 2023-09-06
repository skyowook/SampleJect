//
//  HMac.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation
import CryptoSwift

class HMAC {
    private static let algorithm = "HmacSHA256"
    
    class func calculateHash(_ secret: String, _ message: String) -> String {
        do {
            let bytes = try CryptoSwift.HMAC(key: secret, variant: .sha2(.sha256)).authenticate(Array(message.utf8))
            let data = Data(bytes)
            return data.toHexString()
        } catch {
            print("Hash computation failed")
        }

        return ""
    }
}
