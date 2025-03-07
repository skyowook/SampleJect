//
//  MainView.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI
import IACoreKit

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: StackSampleView()) {
                        Text("StackSample")
                    }
                    Spacer()
                    
                    NavigationLink(destination: ButtonSampleView()) {
                        Text("ButtonSample")
                    }
                    Spacer()
                    
                    NavigationLink(destination: TextSampleView()) {
                        Text("TextSample")
                    }
                }
                .padding(EdgeInsets.hPadding(20))
                
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
