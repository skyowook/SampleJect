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
                NavigationLink(destination: CreatingAndCombiningViews(data: landMarks.first!, isSel: .constant(false))) {
                    Text("CreatingAndCombiningViews")
                }
                
                Divider()
                NavigationLink(destination: BuildingListsAndNavigation()) {
                    Text("BuildingListsAndNavigation")
                }
                
                Divider()
                NavigationLink(destination: HandlingUserInput().environment(LandMarkModel())) {
                    Text("HandlingUserInput")
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    TutorialView()
}
