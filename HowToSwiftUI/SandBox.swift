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

    public var body: some View {
        
        Button("show console: \(showConsole.description)") {
            withAnimation {
                showConsole.toggle()
            }
        }
        .padding()
        
        Button("show interaction location: \(showInteractionLocation.description)") {
            withAnimation {
                showInteractionLocation.toggle()
            }
        }
        .padding()
        
        Text("root")
            .console(presented: showConsole)
            .interactionLocation(presented: showInteractionLocation)
    }
    
}

public extension View {
    
    func interactionLocation(presented: Bool) -> some View {
        self.modifier(Modifier.InteractionLocation(presented: presented))
    }
}


public extension Modifier {
    
    struct InteractionLocation: ViewModifier {
        
        var presented: Bool
        
        @State private var location: CGPoint = CGPoint(x: 50, y: 50)
        
        @GestureState private var fingerLocation: CGPoint? = nil
        
        var fingerDrag: some Gesture {
            DragGesture()
                .updating($fingerLocation) { (value, fingerLocation, transaction) in
                    fingerLocation = value.location
                }
        }
        
        public func body(content: Content) -> some View {
            ZStack {
                
                content
                
                if let fingerLocation = fingerLocation {
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: 44, height: 44)
                        .position(fingerLocation)
                }
            }
            .simultaneousGesture(fingerDrag)
        }
    }
}

// Console

public extension View {
    
    func console(presented: Bool) -> some View {
        self.modifier(Modifier.Console(presented: presented))
    }
}

public extension Modifier {
    
    struct Console: ViewModifier {
        
        var presented: Bool
        
        @State private var location: CGPoint = CGPoint(x: 50, y: 50) {
            didSet {
                print("\(location)")
            }
        }
                
        @GestureState private var startLocation: CGPoint? = nil // 1
        
        var longPress: some Gesture {
            LongPressGesture(minimumDuration: 5.0)
            
                .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                    gestureState = currentState
                }
                .onChanged({ value in
                    withAnimation {
                        allowDragging = true
                    }
                })
                .onEnded({ value in
                    withAnimation {
                        allowDragging = false
                    }
                })
        }
        
        var drag: some Gesture {
            DragGesture()
                .onChanged { value in
                    var newLocation = startLocation ?? location // 3
                    newLocation.x += value.translation.width
                    newLocation.y += value.translation.height
                    self.location = newLocation
                }.updating($startLocation) { (value, startLocation, transaction) in
                    startLocation = startLocation ?? location // 2
                }
        }
        
        var magnification: some Gesture {
            MagnificationGesture()
                .onChanged { amount in
                    
                    magnificationCurrentAmount = amount - 1
                    
                }
                .onEnded { amount in
                    
                    if amount > minMagnificationAmount {
                        
                        magnificationFinalAmount += magnificationCurrentAmount
                        magnificationCurrentAmount = 0
                    }
                }
        }
        
        var resize: some Gesture {
            DragGesture()
            
                .onChanged { value in
                    
                    if width + value.location.x >= minWidth {
                        //                                            width += value.translation.width
                        width = width + value.location.x
                    }
                    
                    if height + value.location.y >= minHeight {
                        //                                            height += value.translation.height
                        height = height + value.location.y
                    }
                    
                    withAnimation {
                        //
                        //                                        if width >= minWidth {
                        //                                            //                                            width += value.translation.width
                        //                                            width = width + value.location.x
                        //                                        }
                        //
                        //                                        if height >= minHeight {
                        //                                            //                                            height += value.translation.height
                        //                                            height = height + value.location.y
                        //                                        }
                        //
                        isMoving = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        isMoving = false
                    }
                }
        }
        
        // frame
        let scaling = 0.5
        var minWidth:CGFloat { 176.0 / scaling }
        var minHeight:CGFloat { 88.0 / scaling }
        @State private var width = 10.0
        @State private var height = 10.0
        let shrinkMultiplier = 0.8
        
        //
        @State private var isMoving = false
        @State private var allowDragging = false
        
        @State private var isHidden = false
        @State var opacity: Double = 1.0

        @GestureState var isDetectingLongPress = false
        
        //
        @State private var magnificationCurrentAmount = 0.0
        @State private var magnificationFinalAmount = 1.0
        let minMagnificationAmount = 0.4
        
        public init(presented: Bool) {
            self.presented = presented
        }
        
        public func body(content: Content) -> some View {
            
            ZStack {
                
                content
                
                if presented {
                    
                    GeometryReader { geometry in
                        
                        ZStack {
                            
                            Group {
                                Rectangle()
                                    .fill(allowDragging ? isMoving ? .purple:.green :.blue)
                                    .cornerRadius(25)
                                    .opacity(isMoving ? 0.1:0.25)
                                
                                Rectangle()
                                    .fill(allowDragging ? isMoving ? .purple:.green :.blue)
                                    .shadow(color: allowDragging ? .green:.blue, radius: allowDragging ? 40:5)
                                    .cornerRadius(25)
                                    .blur(radius: 20)
                                    .padding()
                            }
                            .opacity(isHidden ? 0.0:1.0)
//                            .simultaneousGesture(
//                                DragGesture()
//
//                                    .onChanged { value in
//
//                                        if !allowDragging {
//                                            return
//                                        }
//
//                                        location = value.location
//
//                                        withAnimation {
//
////                                            var newLocation = startLocation ?? location // 3
////
////                                            if newLocation.x + value.translation.width > 8 {
////                                                newLocation.x += value.translation.width
////                                            }
////
////                                            if newLocation.y + value.translation.height > 8 {
////                                                newLocation.y += value.translation.height
////                                            }
////
////                                            self.location = newLocation
//                                            isMoving = true
//                                        }
//                                    }
//                                    .updating($startLocation) { (value, startLocation, transaction) in
//
//                                        if !allowDragging {
//                                            return
//                                        }
//
//                                        withAnimation {
////                                            startLocation = startLocation ?? location // 2
//                                        }
//                                    }
//                                    .onEnded { _ in
//                                        withAnimation {
////                                            allowDragging = false
////                                            isMoving = false
//                                        }
//                                    }
//                            )
                            
                            NavigationView {
                                
                                FilteredList(
                                    list: SandBox.longList) { (string) in
                                        
                                        Text("\(string)")
                                            .font(.system(size: 8))
                                    }
                                
                                    .listStyle(GroupedListStyle())
                                    .navigationViewStyle(StackNavigationViewStyle())
                            }
                            .padding()
                            .opacity(isMoving ? 0.5:1.0)
                            .minimumScaleFactor(0.2)
                            .opacity(isHidden ? 0.0:1.0)
                            
                            buttons()
                            
                        }
                        .position(location)
                        .frame(width: width, height: height)
                        .onAppear {
                            width = max(geometry.size.width * 0.9, minWidth)
                            height = max(geometry.size.height * 0.9 / 3, minHeight)
                            location = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                        .simultaneousGesture(drag.simultaneously(with: longPress))
                        .scaleEffect(magnificationFinalAmount + magnificationCurrentAmount)
                        .simultaneousGesture(magnification)
                        .opacity(opacity)
                    }
                    
                }
            }
            
        }
        
        @ViewBuilder
        func buttons() -> some View {
            HStack {
                Spacer()
                VStack {
                    
                    Spacer()
//
//                    Image(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left") // arrow.up.backward.and.arrow.down.forward.circle.fill
//                        .simultaneousGesture(drag)
//
//                    Spacer()

                    Menu {
                        
//                        HStack {
//                            Text("\(String(format: "%.0f", opacity))%")
//                            Slider(value: $opacity, in: 0...1, step: 0.1)
//                        }
//
//                        Stepper {
//                            Text("\(opacity)")
//                        } onIncrement: {
//                            opacity += 0.1
//                        } onDecrement: {
//                            opacity -= 0.1
//                        } onEditingChanged: { change in
//
//                        }
                        
                        Button {
                            withAnimation {
                                isHidden.toggle()
                            }
                        } label: {
                            Text("\(isHidden ? "un-hide":"hide")")
                            Image(systemName: isHidden ? "eye.slash": "eye")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                    }
                    
//                    Spacer()
//
//                    Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left") // arrow.up.backward.and.arrow.down.forward.circle.fill
//                        .simultaneousGesture(resize)
                }
            }
            .foregroundColor(.blue)
        }
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
