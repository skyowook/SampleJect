//
//  TossCertSession.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation

/// 토스 인증 세션
class TossCertSession {
    static let SEPARATOR = "$"
    
    private let version: String
    private let id: String
    private let algorithm: AESAlgorithm
    private let secretKey: String
    private let iv: String
    private let encryptedSessionKey: String
    private let aesCipher: AESCipher
    
    var sessionKey: String {
        get {
            addMeta(encryptedSessionKey)
        }
    }
    
    init(_ version: String, _ id: String, _ algorithm: AESAlgorithm, _ secretKey: String, _ iv: String, _ encryptedSessionKey: String) {
        self.version = version
        self.id = id
        self.algorithm = algorithm
        self.secretKey = secretKey
        self.iv = iv
        self.encryptedSessionKey = encryptedSessionKey
        self.aesCipher = AESCipher(secretKey, iv, algorithm)
    }
    
    func encrypt(_ plainText: String) -> String {
        let encrypted = aesCipher.encrypt(plainText) ?? ""
        return addMeta(encrypted)
    }
    
    func decrypt(_ encryptedText: String) -> String? {
        let items = encryptedText.components(separatedBy: TossCertSession.SEPARATOR)
        if items.count < 3 {
            debugPrint("암호 문자열 포맷이 다릅니다.")
        } else if version != items.first {
            debugPrint("세션 키 버전이 다릅니다. 세션 키 버전 : \(version) != 암호 문자열 버전 \(items[0])")
        } else if id != items[1] {
            debugPrint("세션 키 id 이 다릅니다. 세션 키 id: \(id) != 암호 문자열 id: \(items[1])")
        }
        
        let plainText = aesCipher.decrypt(items[2])
        return plainText
    }
    
    func serializeSession() -> String {
        return TossUtils.join(TossCertSession.SEPARATOR, [version, id, algorithm.rawValue, secretKey, iv])
    }
    
    private func addMeta(_ data: String) -> String {
        return TossUtils.join(TossCertSession.SEPARATOR, [version, id, data])
    }
}
