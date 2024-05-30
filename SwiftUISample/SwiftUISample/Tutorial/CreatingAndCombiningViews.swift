//
//  AT01.swift
//  SwiftUISample
//
//  Created by skw on 5/29/24.
//

import SwiftUI
import MapKit

struct CreatingAndCombiningViews: View {
    var body: some View {
        VStack {
            section05
                .frame(height: 300)
            VStack {
                section04
                section03
            }.offset(y: -130)
            Spacer()
        }
    }
    
    // Customize the text view
    var section02: some View {
        Text("Turtle Rock")
            .font(.title)
            .foregroundColor(.green)
    }
    
    // Combine views using stacks
    var section03: some View {
        VStack(alignment: .leading) {
            Text("Turtle Rock")
                .font(.title)
            HStack {
                Text("Joshua Tree National Park")
                    .font(.subheadline)
                Spacer()
                Text("Califonia")
                    .font(.subheadline)
            }
            
            Divider()
            
            Text("About Turtle Rock")
                .font(.title2)
            Text("Descriptive text gose here")
        }
        .padding()
    }
    
    // Create a custom image view
    var section04: some View {
        Image("TurtleRock")
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.black, lineWidth: 4)
            }
            .shadow(radius: 10)
    }
    
    
    // Use SwiftUI views from other frameworks
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var section05: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
        
        // IOS 17.0
        // Map(initialPosition: .region(region))
    }
}

#Preview {
    CreatingAndCombiningViews()
}
