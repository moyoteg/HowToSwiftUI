//
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

struct UseLocation: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion()
    @State private var visitedRegions: [Region] = []

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: visitedRegions) { region in
                MapAnnotation(coordinate: region.center) {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .background(Circle().foregroundColor(Color.blue.opacity(0.3)))
                        .frame(width: 10, height: 10)
                }
            }
            .frame(height: 300)
            .cornerRadius(10)
            
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
            ForEach(locationManager.monitoringRegions, id: \.self) { region in
                Text("Identifier: \(region.identifier)")
            }
            
            if let visit = locationManager.didVisit {
                Text("Did Visit:")
                Text("Arrival Date: \(visit.arrivalDate)")
                Text("Departure Date: \(visit.departureDate)")
            }
            
            Button("Generate Sample Data") {
                generateSampleData()
            }
        }
        .onAppear {
            locationManager.requestLocationAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
            let proximityUUID = UUID()
            let region = CLBeaconRegion(uuid: proximityUUID, identifier: "SampleRegion")
            locationManager.startRangingBeacons(in: region)
            
            let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.0312), radius: 500, identifier: "SampleCircularRegion")
            locationManager.startMonitoring(for: circularRegion)
            
            locationManager.startMonitoringVisits()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            
            let proximityUUID = UUID()
            let region = CLBeaconRegion(uuid: proximityUUID, identifier: "SampleRegion")
            locationManager.stopRangingBeacons(in: region)
            
            let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.0312), radius: 500, identifier: "SampleCircularRegion")
            locationManager.stopMonitoring(for: circularRegion)
            
            locationManager.stopMonitoringVisits()
        }
        .onReceive(locationManager.$currentLocation) { location in
            guard let location = location else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
        .onReceive(locationManager.$monitoringRegions) { monitoringRegions in
            visitedRegions = monitoringRegions.compactMap { region in
                guard let circularRegion = region as? CLCircularRegion else { return nil }
                return Region(id: circularRegion.identifier, center: circularRegion.center, radius: circularRegion.radius)
            }
        }

    }
    
    private func generateSampleData() {
        // Generate sample data for different scenarios
        locationManager.authorizationStatus = .authorizedWhenInUse
        locationManager.currentLocation = CLLocation(latitude: 37.3323, longitude: -122.0312)
        locationManager.rangingBeacons = [MockCLBeacon()]
        locationManager.monitoringRegions = [MockCLRegion()]
        locationManager.didVisit = MockCLVisit()
        visitedRegions = locationManager.monitoringRegions.map { region in
            let circularRegion = region as! CLCircularRegion
            return Region(id: circularRegion.identifier, center: circularRegion.center, radius: circularRegion.radius)
        }
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

class MockCLRegion: CLCircularRegion {
    var mockIdentifier: String = "SampleRegion"
    
    override var identifier: String {
        return mockIdentifier
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


struct UseLocation_Previews: PreviewProvider {
    static var previews: some View {
        UseLocation()
    }
}
