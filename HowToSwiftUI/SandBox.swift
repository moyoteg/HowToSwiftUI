//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI
import SwiftUIComponents
import MapKit
import NetworkExtension
import CoreLocation

import SwiftUICharts
import SwiftUtilities

import SystemConfiguration.CaptiveNetwork

struct SandBox: View {
    
    /// *********
    // not using
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
    
    let data: [Double] = [-69, -70, -71, -71, -70, -70, -70, -69, -66]
    /// *********
    
    /// *********
    // using
    @State var title = "Wifi RSSI"
    @State var legend = ""
    @State var networkSSID: String = "--"
    @State var signalStrength: Double? = 0 {
        didSet {
            if let signalStrength = signalStrength {
                
                let historyCapacity = 10
                
                signalStrengthHistory.insert(signalStrength, at: 0)

                if self.signalStrengthHistory.count >= historyCapacity {
                    signalStrengthHistory.removeLast()
                }

            }
        }
    }
    @State var signalStrengthHistory: [Double] = []
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let locationManager = CLLocationManager()
    /// *********

    let height = 100.0
    let width = 150.0
    
    var body: some View {

        RoundedRectangle(cornerRadius: height)
            .fill(.blue.opacity(0.5))
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: height)
                    .fill(.blue.opacity(0.75))
                    .frame(width: width * 0.95, height: height * 0.95)
                    .overlay(
                        RoundedRectangle(cornerRadius: height)
                            .fill(.blue.opacity(1.0))
                            .frame(width: width * 0.85, height: height * 0.85)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: height)
                            .stroke(.green, lineWidth: 8)
                    )
            )
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

/*
import Charts
import SwiftUI

struct SalesSummary: Identifiable {
    let weekday: Date
    let sales: Int
    var id: Date { weekday }
}
let cupertinoData: [SalesSummary] = [
    // Monday
    .init (weekday: date(2022, 5, 2), sales: 54),
    /// Tuesday
    .init (weekday: date(2022, 5, 3), sales: 42),
    /// Wednesday
    .init (weekday: date (2022, 5, 4), sales: 88),
    /// Thursday
    .init (weekday: date(2022, 5, 5), sales: 49),
    /// Friday
    .init (weekday: date (2022, 5, 6), sales: 42),
    /// Saturday
    .init (weekday: date (2022, 5, 7), sales: 125),
    /// Sunday
    .init(weekday: date (2022, 5, 8), sales: 67)
]

struct Series: Identifiable {
    let city: String
    let sales: [SalesSummary]
    var id: String { city }
}

let seriesData: [Series] = [
    .init(city: "Cupertino", sales: cupertinoData)
    .init(city: "San Francisco", sales: sfData),
]

struct LocationsDetailsChart: View {
    var body: some View {
        Chart(seriesData) { series in
            ForEach(series.sales) { element in
                LineMark(
                    X: .value ("Day", element.weekday, unit: .day),
                    y: .value("Sales", element.sales)
                )
                .foregroundStyle(by: .value("City", .symbol(by: •value("City", series.city))))
                
            }
        }
    }
}
*/
