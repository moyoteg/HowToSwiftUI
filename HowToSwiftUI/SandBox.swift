//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI
import SwiftUIComponents
import MapKit

struct SandBox: View {
    
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple] {
        didSet {
            pageCount = colors.count
        }
    }
    var symbols = ["car", "pencil", "bus", "star", "waveform.path.ecg.rectangle"]
    @State var currentPage: Int = 0
    @State var pageCount: Int = 0
    @State var direction: ReflectDirection = .bottom
        
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    
    var body: some View {

        ZStack {
            MapView(centerCoordinate: $centerCoordinate, annotations: locations)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // create a new location
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                    }) {
                        Image(systemName: "location.fill")
                            .animatableSystemFont(size: 20)
                    }
                    .padding()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // create a new location
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                    
                }
            }
        }
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D

    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}


/*
 ZStack {
     ForEach(0..<3) { index in
         Image(systemName: "bus")
             .font(.system(size: 100))
             .zIndex(Double(2 - index))
             .offset(x: 10.0*CGFloat(index), y: -10.0*CGFloat(index))
             .opacity(1.0/(1.0 + Double(index)))
             .brightness(-1.0 + 1/(1 + Double(index)))

     }
 }
 */


