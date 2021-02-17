//
//  InsertAndRemoveViewWithTransition.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI

struct InsertViewWithTransition: View {
    @State private var showDetails = false

    var body: some View {
        VStack {
            Button("Press to show transition") {
                withAnimation {
                    showDetails.toggle()
                }
            }

            Divider()
            
            if showDetails {

                Text("slide")
                    .transition(.slide)

                Text("scale")
                    .transition(.scale)
                
                Text("opacity")
                    .transition(.opacity)
                
                Text("move bottom")
                    .transition(.move(edge: .bottom))
                Text("move leading")
                    .transition(.move(edge: .leading))
                Text("move top")
                    .transition(.move(edge: .top))
                Text("move trailing")
                    .transition(.move(edge: .trailing))
            }
        }
    }
}
