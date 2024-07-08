//
//  HandlingUserInput.swift
//  SwiftUISample
//
//  Created by skw on 6/24/24.
//

import SwiftUI

struct HandlingUserInput: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TutorialModelData.self) var modelData
    @State private var isFilteredList = false
    
    var filteredLandmarks: [Landmark] {
        modelData.landMarks.filter {
            $0.isFavorite || !isFilteredList
        }
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        VStack(alignment: .leading) {
            HStack {
                Text("필터 Switch     ")
                Toggle("", isOn: $isFilteredList).labelsHidden()
            }
            
            List(filteredLandmarks) { data in
                ZStack {
                    LandmarkRow2(landmark: data)
                    NavigationLink {
                        CreatingAndCombiningViews(data: data, isSel: $modelData.landMarks[findIdx(data.id)].isFavorite)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
            }
            .animation(.default, value: filteredLandmarks)
            .listStyle(.plain)
        }
    }
    
    private func findIdx(_ id: Int) -> Int {
        return modelData.landMarks.firstIndex { data in
            id == data.id
        } ?? 0
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
    HandlingUserInput().environment(TutorialModelData())
}
