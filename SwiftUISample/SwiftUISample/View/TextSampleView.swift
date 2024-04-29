//
//  TextSampleView.swift
//  SwiftUISample
//
//  Created by skw on 12/11/23.
//

import SwiftUI

struct TextSampleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("텍스트 관련된 샘플")
            fontStyleText
            customFontText
            fontSizeText
        }.frame(maxWidth: .infinity)
    }
    
    var fontStyleText: some View {
        VStack {
            Text("FontStyle")
            
            HStack(spacing: 5) {
                Text("Bold").fontWeight(.bold)
                Text("Light").fontWeight(.light)
                Text("Italic").italic()
                Text("Medium").fontWeight(.medium)
            }
        }
    }
    
    var customFontText: some View {
        Text("CustomFont")
    }
    
    var fontSizeText: some View {
        Text("FontSize 10")
    }
}

#Preview {
    TextSampleView()
}
