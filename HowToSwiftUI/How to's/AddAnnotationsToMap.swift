//
//  AddAnnotationsToMap.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 9/28/21.
//

import SwiftUI
import MapKit

struct AddAnnotationsToMap: View {
    
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

struct AddAnnotationsToMap_Previews: PreviewProvider {
    static var previews: some View {
        AddAnnotationsToMap()
    }
}
