//
//  TutorialView.swift
//  SwiftUISample
//
//  Created by skw on 5/29/24.
//


import SwiftUI
import IAssistKit

struct TutorialView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CreatingAndCombiningViews(data: landMarks.first)) {
                    Text("CreatingAndCombiningViews")
                }
                
                Divider()
                NavigationLink(destination: BuildingListsAndNavigation()) {
                    Text("BuildingListsAndNavigation")
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    TutorialView()
}
