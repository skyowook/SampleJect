//
//  TextSampleView.swift
//  SwiftUISample
//
//  Created by skw on 10/25/23.
//

import SwiftUI

struct TextSampleView: View {
    @State var isShowing: Bool = false
    var message: String = "Test"
    var rotationMenuView = RotateMenuView()
    var body: some View {
        ZStack {
            VStack {
                Text("asdkfjas;lkdfj;lk").background(.red, ignoresSafeAreaEdges: .bottom)
                List {
                    ForEach(0..<40) { index in
                        SampleItemView().listRowInsets(EdgeInsets())
                            .frame(height:80)
                    }
                }.listStyle(.plain).frame(height: 400)
                Spacer()
                Text("Bottom")
            }.onTapGesture {
                isShowing = true
            }
//            .alert(message, isPresented: $isShowing) {
//                Button("ok", role: .cancel) {
//                    debugPrint("Cancel")
//                }
//            }
            rotationMenuView.show($isShowing).onTapGesture {
                isShowing = false
            }
        }.navigationBarBackButtonHidden()
    }
}


#Preview {
    TextSampleView()
}
