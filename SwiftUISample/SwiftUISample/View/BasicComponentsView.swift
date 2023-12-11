//
//  BasicComponentsView.swift
//  SwiftUISample
//
//  Created by skw on 12/11/23.
//

import SwiftUI

struct BasicComponentsView: View {
    var body: some View {
        VStack {
            ButtonSampleView()
            TextSampleView().padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            Spacer()
        }
    }
}

#Preview {
    BasicComponentsView()
}
