//
//  rotate3DEffect.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/17/21.
//

import SwiftUI

struct Rotate3DEffect: View {
    
    var body: some View {
        
        Text("Rotated 45° text along x axis")
        .font(.largeTitle)
        .rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))
    }
    
}
