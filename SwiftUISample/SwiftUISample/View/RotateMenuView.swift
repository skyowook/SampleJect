//
//  RotateMenuView.swift
//  SwiftUISample
//
//  Created by skw on 11/2/23.
//

import SwiftUI

struct RotateMenuView: View {
    var body: some View {
        ZStack {
            Text("asdasdfasff")
        }.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all).background(Color(red:0.5, green: 0.5, blue: 0.5, opacity: 0.5))
    }
    
    func show(_ flag: Binding<Bool>) -> some View {
        return body.opacity(flag.wrappedValue ? 1 : 0)
    }
}

#Preview {
    RotateMenuView()
}
