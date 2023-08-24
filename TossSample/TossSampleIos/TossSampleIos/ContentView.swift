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
            })
        }
    }
}

#Preview {
    ContentView()
}
