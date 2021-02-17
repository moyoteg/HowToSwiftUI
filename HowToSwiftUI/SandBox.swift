//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI

struct SandBox: View {
    
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = "Red"
    @State private var isPresented = false
    
    var body: some View {
        Button("show menu") {
            withAnimation {
                isPresented = true
            }
        }
        .popUp(isPresented: $isPresented) {
            Button("hide menu") {
                withAnimation {
                    isPresented = false
                }
            }
        }
        
    }
}
