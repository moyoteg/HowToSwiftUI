//  UseLocation.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 6/5/23.
//

import SwiftUI
import CoreLocation
import MapKit

import SwiftUIComponents
import SwiftUtilities

import SwiftUI
import CoreLocation
import MapKit

struct UseLocation: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion()
    @ObservedObject private var visitHistoryManager = VisitHistoryManager()
    @State private var monitoredRegions: [RegionWrapper] = []
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: monitoredRegions) { region in
                MapAnnotation(coordinate: region.center) {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .background(Circle().foregroundColor(Color.blue.opacity(0.3)))
                        .frame(width: 10, height: 10)
                }
            }
            .frame(height: 300)
            .cornerRadius(10)
            
            ScrollView {
                Text("Authorization Status: \(locationManager.authorizationStatus.rawValue)")
                
                if let location = locationManager.currentLocation {
                    Text("Latitude: \(location.coordinate.latitude)")
                    Text("Longitude: \(location.coordinate.longitude)")
                }
                
                if let heading = locationManager.heading {
                    if heading.headingAccuracy >= 0 {
                        Text("Heading: \(heading.trueHeading)")
                    } else {
                        Text("Heading: N/A")
                    }
                }
                
                Text("Ranging Beacons:")
                ForEach(locationManager.rangingBeacons, id: \.self) { beacon in
                    Text("UUID: \(beacon.uuid)")
                    Text("Major: \(beacon.major)")
                    Text("Minor: \(beacon.minor)")
                    Text("Accuracy: \(beacon.accuracy)")
                }
                
                Text("Monitoring Regions:")
                ForEach(monitoredRegions, id: \.id) { region in
                    Text("Identifier: \(region.identifier)")
                }
                
                Text("Visit History:")
                ForEach(visitHistoryManager.visitHistory, id: \.arrivalDate) { visit in
                    VStack {
                        Text("Arrival Date: \(visit.arrivalDate)")
                        Text("Departure Date: \(visit.departureDate)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                
                Button("Generate Sample Data") {
                    generateSampleData()
                }
            }
        }
        .onAppear {
            locationManager.requestLocationAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            locationManager.startMonitoringVisits()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            locationManager.stopMonitoringVisits()
        }
        .onReceive(locationManager.$currentLocation) { location in
            guard let location = location else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
        .onReceive(locationManager.$monitoringRegions) { monitoringRegions in
            monitoredRegions = monitoringRegions.map { RegionWrapper(region: $0) }
            visitHistoryManager.visitHistory = locationManager.visitHistory
        }
    }
    
    private func generateSampleData() {
        // Generate sample data for different scenarios
        locationManager.authorizationStatus = CLAuthorizationStatus.authorizedWhenInUse
        locationManager.currentLocation = CLLocation(latitude: 37.3323, longitude: -122.0312)
        locationManager.rangingBeacons = [MockCLBeacon()]
        locationManager.monitoringRegions = [MockCLCircularRegion()]
        monitoredRegions = locationManager.monitoringRegions.map { RegionWrapper(region: $0) }
        
        let sampleVisit = MockCLVisit()
        locationManager.visitHistory.append(sampleVisit)
        visitHistoryManager.visitHistory.append(sampleVisit)
    }
}

struct RegionWrapper: Identifiable {
    let region: CLRegion
    
    var id: String {
        return region.identifier
    }
    
    var identifier: String {
        return region.identifier
    }
    
    var center: CLLocationCoordinate2D {
        if let circularRegion = region as? CLCircularRegion {
            return circularRegion.center
        } else {
            // You can handle other region types if needed
            return kCLLocationCoordinate2DInvalid
        }
    }
    
    var radius: CLLocationDistance {
        if let circularRegion = region as? CLCircularRegion {
            return circularRegion.radius
        } else {
            // You can handle other region types if needed
            return 0
        }
    }
}

class VisitHistoryManager: ObservableObject {
    @Published var visitHistory: [CLVisit] = []
}

class MockCLCircularRegion: CLCircularRegion {
    var mockIdentifier: String = "SampleCircularRegion"
    var mockCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.0312)
    var mockRadius: CLLocationDistance = 500.0
    
    override var identifier: String {
        return mockIdentifier
    }
    
    override var center: CLLocationCoordinate2D {
        return mockCenter
    }
    
    override var radius: CLLocationDistance {
        return mockRadius
    }
}

class MockCLVisit: CLVisit {
    var mockArrivalDate: Date = Date()
    var mockDepartureDate: Date = Date()
    
    override var arrivalDate: Date {
        return mockArrivalDate
    }
    
    override var departureDate: Date {
        return mockDepartureDate
    }
}


class MockCLHeading: CLHeading {
    var mockTrueHeading: CLLocationDirection = 0.0
    
    override var trueHeading: CLLocationDirection {
        return mockTrueHeading
    }
    
    override var magneticHeading: CLLocationDirection {
        return mockTrueHeading
    }
    
    override var headingAccuracy: CLLocationDirection {
        return 0.0
    }
    
    override var x: CLHeadingComponentValue {
        return 0.0
    }
    
    override var y: CLHeadingComponentValue {
        return 0.0
    }
    
    override var z: CLHeadingComponentValue {
        return 0.0
    }
    
    override var timestamp: Date {
        return Date()
    }
}

class MockCLBeacon: CLBeacon {
    var mockUUID: UUID = UUID()
    var mockMajor: NSNumber = 0
    var mockMinor: NSNumber = 0
    var mockAccuracy: CLLocationAccuracy = 0.0
    
    override var uuid: UUID {
        return mockUUID
    }
    
    override var major: NSNumber {
        return mockMajor
    }
    
    override var minor: NSNumber {
        return mockMinor
    }
    
    override var accuracy: CLLocationAccuracy {
        return mockAccuracy
    }
    
    override var proximity: CLProximity {
        return .unknown
    }
    
    override var rssi: Int {
        return 0
    }
}

struct Region: Identifiable {
    let id: String
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
}

struct UseLocation_Previews: PreviewProvider {
    static var previews: some View {
        UseLocation()
    }
}
