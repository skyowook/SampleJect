//
//  MainView.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI
import IAssistKit

struct MainView: View {
    @State var mainValue = 10
    var body: some View {
        VStack {
            NavigationView {
                NavigationLink(destination: TextSampleView().environment(\.mainValue, mainValue)
                ) {
                    Text("go to test1")
                }
            }
        }
    }
}

#Preview {
    MainView()
}

