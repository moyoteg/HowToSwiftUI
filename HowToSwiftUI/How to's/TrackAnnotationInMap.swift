//
//  TrackAnnotationInMap.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/13/21.
//

import SwiftUI
import MapKit

struct TrackAnnotationInMap: View {
    
    struct Annotation: Identifiable, Hashable {
        var id: Int { hashValue }
        var name: String
        let latitude: Double
        let longitude: Double
        var coordinate: CLLocationCoordinate2D {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            if CLLocationCoordinate2DIsValid(coordinate) {
                return coordinate
            } else {
                return CLLocationCoordinate2D()
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(latitude)
            hasher.combine(longitude)
        }
    }
        
    @State var annotations: [Annotation] = []
    
    @State var region =
        MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0,
            longitude: 0),
        span: MKCoordinateSpan(
            latitudeDelta: 180,
            longitudeDelta: 360))
    
    @State var timeRemaining = 10
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @State var routeIsActive = false
    
    @State var trackAnnotation = true
    
    @State var annotation = Annotation(name: "bus",
                                       latitude: 0.0,
                                       longitude: 0.0) {
        didSet {
            
            annotations = [
                annotation
            ]
            
            updateRegion()
        }
    }
    
    var body: some View {
        ZStack {
            VStack{
                HStack {

                    Circle()
                        .foregroundColor(routeIsActive ? timeRemaining.isMultiple(of: 2) ?.green:.red:.blue)
                        .fixedSize()
                        .padding()
                    
                    Spacer()

                    Button("\(routeIsActive ? "stop":"start") random annotation update") {
                        routeIsActive.toggle()
                    }
                    .padding()
                }
                
                Map(coordinateRegion: $region, annotationItems: annotations) {
                    annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        Image(systemName: annotation.name)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.purple)
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    }
                }
                .onAppear {
                    annotations = [annotation]
                }
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    
                    if routeIsActive {
                        withAnimation {
                            annotation = Annotation(name: "figure.wave",
                                                    latitude: Double.random(in: -90.0...90.0),
                                                    longitude: Double.random(in: -180...180.0))
                        }
                    }
                }
                
            }
        }
    }
    
    func updateRegion() {
        withAnimation(Animation.easeInOut(duration: 1.0)) {
            // zooom in to annotation
            region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.005))
        }
    }
}

struct TrackAnnotationInMap_Previews: PreviewProvider {
    static var previews: some View {
        TrackAnnotationInMap()
            
            
    }
}
