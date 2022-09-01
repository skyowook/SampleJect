//
//  TestUIView.swift
//  SampleJect
//
//  Created by ben on 2022/09/01.
//  Copyright © 2022 SinKyoUk. All rights reserved.
//

import SwiftUI

struct TestUIView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            var text = Text("Placeholder")
            text.bold()
            
            Text("안녕하세요 안녕하 세 요 안 녕 하 세 요 안녕하세요안 녕하세요안녕하세 요안녕하세요안녕하세 요 안 녕 하세요안녕하세 요 안 녕 하 세 요 안 녕 하 세 요 안 녕 하 세 요 ").multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        
    }
}

struct TestUIView_Previews: PreviewProvider {
    static var previews: some View {
        TestUIView()
    }
}
