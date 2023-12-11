//
//  ButtonTestView.swift
//  SwiftUISample
//
//  Created by skw on 12/11/23.
//

import SwiftUI

struct ButtonSampleView: View {
    var body: some View {
        HStack {
            Spacer()
            Button("기본 버튼") {
                // action click
            }
            Spacer()
            Button("라운딩 버튼") {
                
            }
            Spacer()
        }
    }
}

#Preview {
    ButtonSampleView()
}
