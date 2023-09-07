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
//                tossWeb.tossLoad()
                test()
            })
        }
    }
    
    func test() {
        let cipher = AESCipher("RgmEkDlZYMIfBa9BQlC9l36FlzG5X9Vz+3ZK6yyLPZg=", "4efcrC76ZCwrt+pT")
        debugPrint(cipher.decrypt("D2n4NwqsWqM7Uk0q3+eAGy55rL0="))
    }
}

#Preview {
    ContentView()
}
