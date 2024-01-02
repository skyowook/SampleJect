//
//  StackSampleView.swift
//  SwiftUISample
//
//  Created by skw on 12/12/23.
//

import SwiftUI

struct StackSampleView: View {
    @State var flag: Bool = false
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
        }
    }
    
    var sampleHStack: some View {
        return HStack {
            Text("test01")
        }
    }
    
    var sampleVStack: some View {
        return VStack {
            Text("test02")
        }
    }
}

#Preview {
    StackSampleView()
}
