//
//  ContentView.swift
//  TossSampleIos
//
//  Created by skw on 8/22/23.
//

import SwiftUI

struct ContentView: View {
    var tossWeb = TossWebViewWrapper()
    var body: some View {
        VStack {
            tossWeb.onAppear(perform: {
                tossWeb.tossLoad()
//                test()
            })
        }
    }
    
    func test() {
        let cipher = AESCipher("RgmEkDlZYMIfBa9BQlC9l36FlzG5X9Vz+3ZK6yyLPZg=", "4efcrC76ZCwrt+pT")
        let encrypt = cipher.encrypt("test")
        let decrypt = cipher.decrypt(encrypt ?? "")
        
//        let encoded = "test".data(using: .utf8)?.base64EncodedString()
//        debugPrint("encode ::: \(encoded) decode ::: \(decoded)")
        debugPrint("encrypt ::: \(encrypt) decrypt ::: \(decrypt)")
        debugPrint(cipher.decrypt("kbULrpYE9kFSFJ9PjBagqhiKxSK5YwDzBA=="))
    }
}

#Preview {
    ContentView()
}
