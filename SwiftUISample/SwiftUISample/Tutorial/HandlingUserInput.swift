//
//  HandlingUserInput.swift
//  SwiftUISample
//
//  Created by skw on 6/24/24.
//

import SwiftUI

struct HandlingUserInput: View {
    @Environment(\.dismiss) var dismiss
    @State private var isFilteredList = false
    
    var filteredLandmarks: [Landmark] {
        landMarks.filter {
            $0.isFavorite || !isFilteredList
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("필터 Switch     ")
                Toggle("", isOn: $isFilteredList).labelsHidden()
            }
            
            List(filteredLandmarks) { data in
                ZStack {
                    LandmarkRow2(landmark: data)
                    NavigationLink {
                        CreatingAndCombiningViews(data: data)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct LandmarkRow2: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}


#Preview {
    HandlingUserInput()
}
