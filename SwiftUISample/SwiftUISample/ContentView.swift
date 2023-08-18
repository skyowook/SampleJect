//
//  ContentView.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Toggle(isOn: .constant(false), label: {
                
            })
            Link(destination: URL(string: "https://www.naver.com")!) {
                Text("Link")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

