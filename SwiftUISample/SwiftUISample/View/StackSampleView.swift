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
                }.disabled(flag)
                
                Button("VStack") {
                    flag = false
                }.disabled(!flag)
            }
            borderStack
            shadowStack
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
    
    var borderStack: some View {
        return HStack {
            Text("Border\nStackView")
                .multilineTextAlignment(.center)
        }
        .frame(width: 200, height: 70)
        .border(Color.hex("8000ff00"), width: 5)
    }
    
    @State var testValue: String = "1234"
    var shadowStack: some View {
        return ZStack {
            Text(testValue)
        }
        .frame(width: 200, height: 50)
        .background(RoundedRectangle(cornerRadius: 25.0)
            .fill(.white)
            .shadow(color: .black, radius: 3, x: 3, y: 3))
        .background(RoundedRectangle(cornerRadius: 25.0).stroke(.black).shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/))
        .onTapGesture {
            testValue = "Tesadfkasjdflkjasklasdasdfffjklted"
            debugPrint("Test")
        }
        
        
        
        
    }
}

#Preview {
    StackSampleView()
}
