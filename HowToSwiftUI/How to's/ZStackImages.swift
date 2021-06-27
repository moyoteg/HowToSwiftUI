//
//  ZStackImages.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 3/17/21.
//

import SwiftUI

struct ZStackImages: View {
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Image(systemName: "bus.fill")
                    .font(.system(size: 50))
                    .zIndex(Double(index))
                    .offset(x: 5.0*CGFloat(index), y: -5.0*CGFloat(index))
                    .opacity(1.0/(1.0 + Double(index)))
            }
        }
    }
}
