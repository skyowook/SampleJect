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
                    VStack { sampleVStack }
                }
            }
            Spacer()
            
            stackViewBorder.border(.black)
            spacingStack
            
            Spacer()
            
        }
    }
    
    var sampleHStack: some View {
        return HStack {
            Text("Text01")
            Text("Text02")
            Text("Text03")
        }
    }
    
    @ViewBuilder
    var sampleVStack: some View {
        Text("Text01")
        Text("Text02").padding([.top, .bottom], 50)
        Text("Text03")
        Text("Text03")
    }
    
    /// Empty일때는 border가 나오지 않음? 컨텐츠가 없으면 사이즈가 생성되지 않는거 같기도
    var stackViewBorder: some View {
        return VStack {
            EmptyView()
        }.frame(width: 100, height: 100)
    }
    
    var borderStack: some View {
        let test = HStack {
            Text("Border\nStackView")
                .multilineTextAlignment(.center)
        }
        .frame(width: 200, height: 70)
        
        return if stackFlag {
            test.border(.black, width: 5)
        } else {
            test.border(Color.hex("8000ff00"), width: 5)
        }
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
    
    /// 기본 간격을 지울때는 생성할 당시에 spacing값을 주어야한다.
    var spacingStack: some View {
        HStack(spacing: 0) {
            Text("간격 0")
            Text("간격 0")
        }
    }
}

#Preview {
    StackSampleView()
}
