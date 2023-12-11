//
//  MainView.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI
import IAssistKit

struct MainView: View {
    var body: some View {
        VStack {
            NavigationView {
                NavigationLink(destination: BasicComponentsView()) {
                    Text("GO BasicSample")
                }
            }
        }
    }
}

#Preview {
    MainView()
}

