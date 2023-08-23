//
//  MainView.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI
import IAssistKit

struct MainView: View {
    var textBackgroundColor: Color = .res("testColor")
    var body: some View {
        VStack {
            HStack {
                Text("Test1asdfwerasdfqwerasdfqeradfqewradsfqweradsfqwerasdfqwer")
                    .lineLimit(1)
                    .background(.blue)
                Text("Test2")
                    .font(.appleSDGothic(50, .heavy))
                    .padding(.all, 10)
                    .border(.yellow)
                    .padding(.all, 10)
                    .border(.black)
                    .padding(.all, 20)
                    .background(textBackgroundColor)
                Text("Test3")
                    .background(.white)
                
            }.background(.red)
        }
    }
}

#Preview {
    MainView()
}

