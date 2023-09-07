//
//  TossUtils.swift
//  TossSampleIos
//
//  Created by skw on 9/4/23.
//

import Foundation

enum AESAlgorithm: String {
    case AES_GCM = "AES/GCM/NoPadding"
}

class TossUtils {
    class func join(_ separator: String, _ dataList: [String]) -> String {
        if dataList.isEmpty == true {
            return ""
        } else if dataList.count == 1 {
            return dataList[0]
        }
        
        var builder = ""
        builder.append(dataList[0])
        for i in 1 ..< dataList.count {
            if dataList[i].isEmpty {
                continue
            }
            
            builder.append(separator)
            builder.append(dataList[i])
        }
        
        return builder
    }
}

extension Data {
    func base64Encode(_ data: Data) -> String {
        return data.base64EncodedString().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    func base64Decode() -> Data? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
        return data
    }
    
    func base64Decoded() -> String? {
        if let data = self.base64Decode() {
            return String(decoding: data, as: UTF8.self)
        }
        
        return self
    }
}
