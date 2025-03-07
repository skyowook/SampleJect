//
//  TutorialView.swift
//  SwiftUISample
//
//  Created by skw on 5/29/24.
//

import SwiftUI
import IACoreKit

struct TutorialView: View {
    var body: some View {
        NavigationView {
            VStack {
                let combineView = CreatingAndCombiningViews(data: landMarks.first!, isSel: .constant(false))
                NavigationLink(destination: combineView) {
                    Text("CreatingAndCombiningViews")
                }
                
                Divider()
                NavigationLink(destination: BuildingListsAndNavigation()) {
                    Text("BuildingListsAndNavigation")
                }
                
                Divider()
                NavigationLink(destination: HandlingUserInput().environment(TutorialModelData())) {
                    Text("HandlingUserInput")
                }
                
                Divider()
                NavigationLink(destination: Badge()) {
                    Text("DrawingPathsAndShapes")
                }
                
                Divider()
                NavigationLink(destination: EmptyView()) {
                    Text("AnimatingViewsAndTransitions")
                }
                
                Spacer()
            }
        }
    }
}

func loadTutorialData<T: Decodable>(_ fileName: String) -> T {
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Couldn't find \(fileName) in main bundle.")
    }
    
    do {
        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Fail decode")
    }
}

#Preview {
    TutorialView()
}
