//
//  SecureKeyGenerator.swift
//  TossSampleIos
//
//  Created by skw on 9/5/23.
//

import Foundation

class SecureKeyGenerator {
    class func generateRandomBytes(_ lengthInBits: Int) -> String {
        return Data(createRandomValue(lengthInBits / 8)).base64EncodedString()
    }
    
    private class func createRandomValue(_ count: Int) -> [UInt8] {
        return (0..<count).map({ _ in UInt8.random(in: 0...UInt8.max) })
    }
}
