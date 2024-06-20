//
//  BuildingListsAndNavigation.swift
//  SwiftUISample
//
//  Created by skw on 5/29/24.
//

import SwiftUI
import CoreLocation

struct BuildingListsAndNavigation: View {
    var body: some View {
        List(landMarks) { value in
            NavigationLink {
                CreatingAndCombiningViews(data: value)
            } label: {
                LandmarkRow(landmark: value)
            }
        }
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

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}

var landMarks: [Landmark] = load("landmarkData.json")
func load<T: Decodable>(_ fileName: String) -> T {
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
    BuildingListsAndNavigation()
}
