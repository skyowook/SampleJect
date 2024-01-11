//
//  StackSampleView.swift
//  SwiftUISample
//
//  Created by skw on 12/12/23.
//

import SwiftUI

struct StackSampleView: View {
    @State var flag: Bool = true
    var body: some View {
        VStack {
            HStack {
                Button("HStack") {
                    flag = true
                }
                
                Button("VStack") {
                    flag = false
                }
            }
            Spacer().frame(height: 20)
            ZStack {
                if flag {
                    sampleHStack
                } else {
                    sampleVStack
                }
            }
            
            Spacer()
            
            stackViewBorder.border(.black)
        }
    }
    
    var sampleHStack: some View {
        return HStack {
            Text("Text01")
            Text("Text02")
            Text("Text03")
        }
    }
    
    var sampleVStack: some View {
        return VStack {
            Text("Text01")
            Text("Text02").padding([.top, .bottom], 50)
            Text("Text03")
        }
    }
    
    var stackViewBorder: some View {
        return VStack {
            EmptyView()
        }
    }
}

#Preview {
    StackSampleView()
}
