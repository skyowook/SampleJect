//
//  SecureKeyGenerator.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation
import CryptoSwift

class SecureKeyGenerator {
    class func generateKey(_ aesKeyBitLength: Int) -> String {
        let randomIv = AES.randomIV(aesKeyBitLength / 8)
        return Data(randomIv).base64EncodedString()
    }

    class func generateRandomBytes(_ lengthInBits: Int) -> String {
        let randomIv = AES.randomIV(lengthInBits / 8)
        return Data(randomIv).base64EncodedString()
    }
}
