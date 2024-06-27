//
//  AT01.swift
//  SwiftUISample
//
//  Created by skw on 5/29/24.
//

import SwiftUI
import MapKit

struct BackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "arrowshape.left.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 30)
    }
}

struct CreatingAndCombiningViews: View {
    @Environment(\.dismiss) var dismiss
    var data: Landmark?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                section05
                .frame(height: 300)
                section04
                .offset(y: -130)
                .padding(.bottom, -130)
                section03
                Spacer()
            }
            
            Button("") {
                dismiss()
            }
            .buttonStyle(BackButtonStyle())
        }
        .navigationBarHidden(true)
    }
    
    // Customize the text view
    var section02: some View {
        Text(data?.name ?? "")
            .font(.title)
            .foregroundColor(.green)
    }
    
    // Combine views using stacks
    var section03: some View {
        VStack(alignment: .leading) {
            Text(data?.name ?? "")
                .font(.title)
            HStack {
                Text(data?.park ?? "")
                    .font(.subheadline)
                Spacer()
                Text(data?.state ?? "")
                    .font(.subheadline)
            }
            
            Divider()
            
            Text("About \(data?.name ?? "")")
                .font(.title2)
            Text(data?.description ?? "")
        }
        .padding()
    }
    
    // Create a custom image view
    var section04: some View {
        data?.image
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
    }
}

#Preview {
    CreatingAndCombiningViews(data: landMarks[0])
}
