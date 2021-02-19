//
//  UseButton.swift
//  watchos WatchKit Extension
//
//  Created by Moi Gutierrez on 2/19/21.
//

import SwiftUI

struct UseButton: View {
    
    @State var toggle = false
    
    var body: some View {
        Button("toggle") {
            withAnimation {
                toggle.toggle()
            }
        }
        .padding()
        if toggle {
            Rectangle()
                .fill(Color.green)
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(5)
                .shadow(color: Color.green, radius: 3)
                .padding()
                .transition(.scale)
        }
    }
    
}
