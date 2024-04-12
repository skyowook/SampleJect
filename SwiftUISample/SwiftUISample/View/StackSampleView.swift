//
//  StackSampleView.swift
//  SwiftUISample
//
//  Created by skw on 12/12/23.
//

import SwiftUI

struct StackSampleView: View {
    // HStack, Vstack View Flag
    @State var stackFlag: Bool = true
    @State var testValue: String = "1234"
    
    var body: some View {
        VStack {
            HStack {
                Button("HStack") {
                    stackFlag = true
                }.disabled(stackFlag)
                
                Button("VStack") {
                    stackFlag = false
                }.disabled(!stackFlag)
            }
            borderStack
            shadowStack
            Spacer().frame(height: 20)
            ZStack {
                if stackFlag {
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
    
    var borderStack: some View {
        return HStack {
            Text("Border\nStackView")
                .multilineTextAlignment(.center)
        }
        .frame(width: 200, height: 70)
        .border(Color.hex("8000ff00"), width: 5)
    }
    
    
    var shadowStack: some View {
        return ZStack {
            Text(testValue).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)).lineLimit(1)
        }
        .frame(width: 200, height: 50, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 25.0).stroke(.black))
        .background(RoundedRectangle(cornerRadius: 25.0).fill(.white).shadow(color: .black, radius: 5, x: 1, y: 1))
        .onTapGesture {
            testValue = "Tesated"
            debugPrint("Test")
        }
    }
}

#Preview {
    StackSampleView()
}
