//
//  ShowInteractionLocation.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 1/16/23.
//

import SwiftUI

struct ShowInteractionLocation: View {
    
    @State var showInteractionLocation = false

    public var body: some View {
        
        Button("show interaction location: \(showInteractionLocation.description)") {
            withAnimation {
                showInteractionLocation.toggle()
            }
        }
        .padding()
        
        NavigationView {
            Text("hello world")
        }
        .interactionLocation(presented: showInteractionLocation)
    }
}

struct ShowInteractionLocation_Previews: PreviewProvider {
    static var previews: some View {
        ShowInteractionLocation()
    }
}
