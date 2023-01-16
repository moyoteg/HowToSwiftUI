//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI
import MapKit
import NetworkExtension
import CoreLocation
import SystemConfiguration.CaptiveNetwork

import SwiftUIComponents
import SwiftUICharts
import SwiftUtilities
import CloudyLogs

// Permissions
import PermissionsKit
import NotificationPermission
import BluetoothPermission
import FaceIDPermission
import CameraPermission
import PhotoLibraryPermission
import NotificationPermission
import MicrophonePermission
import CalendarPermission
import ContactsPermission
import RemindersPermission
import SpeechRecognizerPermission
import LocationWhenInUsePermission
import LocationAlwaysPermission
import MotionPermission
import MediaLibraryPermission
import BluetoothPermission
import TrackingPermission
import FaceIDPermission
import SiriPermission
import HealthPermission

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
    
    @State var percentage: Double = 0
    
    var currentWidth: Double {
        width * percentage/100
    }
    
    @State private var isPresented = false
    
    @State var listSelection: Lists = .symbol
    
    enum Lists: String, CaseIterable, Identifiable {
        
        var id: String { self.rawValue }
        
        case symbol
        case symbol2
    }
    
    var symbols2 = ["waveform.path.ecg.rectangle", "pencil", "star"]
    
    private var listToPresent: [String] {
        switch listSelection {
        case .symbol:
            return symbols
        case .symbol2:
            return symbols2
        }
    }
    
    static var longList:[String] = {
        
        var logs = [String]()
        
        for log in 1...100 {
            logs.append("log: \(log)")
        }
        
        return logs
    }()
    
    @State var showConsole = false

    @State var showInteractionLocation = false

    @State var newMessage = "test"

    public var body: some View {
        
        ChatThread(newMessage: newMessage)
    }
    
}

// MARK: - Experimentations

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


import SwiftUI

struct ChatThread: View {
    
    @State var newMessage: String
    
    @State private var messages = [
        Message(content: "Hey, how's it going?", sender: "John"),
        Message(content: "Not too bad, how about you?", sender: "Jane"),
        Message(content: "I'm good, thanks for asking. What's up?", sender: "John"),
        Message(content: "Just wanted to catch up and see how things are going.", sender: "Jane"),
        Message(content: "Things are going well, thanks for asking. How about you?", sender: "John"),
        Message(content: "I'm good too, thanks. Let's catch up again soon.", sender: "Jane")
    ]
    
    var body: some View {
        VStack {
            List {
                ForEach(messages) { message in
                    HStack {
                        Text(message.sender)
                            .font(.caption)
                        Spacer()
                        Text(message.content)
                            .padding(.all, 10)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
            }
            HStack {
                TextField("Enter message", text: $newMessage)
                Button(action: {
                    self.messages.append(Message(content: self.newMessage, sender: "Me"))
                    self.newMessage = ""
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
    }
}

struct Message: Identifiable {
    var id: Int {
        content.hashValue + sender.hashValue
    }
    
    var content: String
    var sender: String
}

struct ChatThread_Previews: PreviewProvider {
    static var previews: some View {
        ChatThread(newMessage: "hellow world")
    }
}
