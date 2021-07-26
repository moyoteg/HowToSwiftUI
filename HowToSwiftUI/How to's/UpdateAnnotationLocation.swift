//
//  UpdateAnnotationLocation.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/21/21.
//

import SwiftUI
import MapKit

struct UpdateAnnotationLocation: View {
    
    struct Annotation: Identifiable, Hashable {
        var id: Int { hashValue }
        var name: String
        let latitude: Double
        let longitude: Double
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        func hash(into hasher: inout Hasher) {
            // to check if annotation is already being drawn
            hasher.combine(name)
            hasher.combine(latitude)
            hasher.combine(longitude)
        }
    }
        
    @State var annotations = [
        Annotation(name: "bus", latitude: 0, longitude: 0),
    ]
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90))
    
    var body: some View {
        ZStack {
            VStack{
                HStack {
                    
                    Button("clear") {
                        annotations.removeAll()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("update location") {
                        
                        annotations = [
                            Annotation(name: "bus",
                                       latitude: Double.random(in: -90.0...90.0),
                                       longitude: Double.random(in: -180...180.0)),
                        ]
                    }
                    .padding()
                }
                
                Map(coordinateRegion: $region, annotationItems: annotations) {
                    annotation in
                    MapAnnotation(coordinate: annotation.coordinate, anchorPoint: CGPoint(x: 0, y: 0)) {
                        Image(systemName: annotation.name)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                }
                
            }
        }
    }
}

struct UpdateAnnotationLocation_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAnnotationLocation()
    }
}
