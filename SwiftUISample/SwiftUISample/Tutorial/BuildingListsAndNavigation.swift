//
//  BuildingListsAndNavigation.swift
//  SwiftUISample
//
//  Created by skw on 5/29/24.
//

import SwiftUI
import CoreLocation

struct BuildingListsAndNavigation: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("") {
                dismiss()
            }
            .buttonStyle(BackButtonStyle())
            
            List(landMarks) { value in
                ZStack {
                    LandmarkRow(landmark: value)
                    NavigationLink {
                        CreatingAndCombiningViews(data: value, isSel: .constant(false))
                    } label: {
                        EmptyView()
                    }.opacity(0)
                }
            }
            .listStyle(.plain)
        }
        .navigationBarHidden(true)
    }
}

struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
        }
    }
}

#Preview {
    BuildingListsAndNavigation()
}
