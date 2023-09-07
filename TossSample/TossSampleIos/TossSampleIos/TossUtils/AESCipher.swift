//
//  AESCipher.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation
import CryptoKit

class AESCipher {
    private let secretKeySpec: [UInt8]
    private let ivSpec: BlockMode
    private var algorithm: AESAlgorithm
    
    init(_ secretKey: String, _ iv: String, _ algorithm: AESAlgorithm = .AES_GCM) {
        self.secretKeySpec = secretKey.base64Decode()!.bytes
        self.algorithm = algorithm
        self.ivSpec = GCM(iv: iv.base64Decode()!.bytes, additionalAuthenticatedData: secretKeySpec, mode: .combined)
    }
    
    func encrypt(_ plainText: String) -> String? {
        let cipher = getCipher()
        if let bytes = try? cipher?.encrypt(plainText.bytes) {
            return Data(bytes).base64EncodedString()
        }
        
        return nil
    }
    
    func decrypt(_ cipherText: String) -> String? {
        let cipher = getCipher()
        let decoedeBytes = cipherText.base64Decode()!.bytes
        if let bytes = try? cipher?.decrypt(decoedeBytes) {
            return String(decoding: Data(bytes), as: UTF8.self)
        }
        
        return nil
    }
    
    private func getCipher() -> AES? {
        return try? AES(key: self.secretKeySpec, blockMode: self.ivSpec, padding: .noPadding)
    }
}
