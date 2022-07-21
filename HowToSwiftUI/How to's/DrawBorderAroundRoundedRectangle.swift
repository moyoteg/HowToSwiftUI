//
//  DrawBorderAroundRoundedRectangle.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/20/22.
//

import SwiftUI

struct DrawBorderAroundRoundedRectangle: View {
    
    let height = 100.0
    let width = 150.0
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: height)
            .fill(.blue.opacity(0.5))
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: height)
                    .fill(.blue.opacity(0.75))
                    .frame(width: width * 0.95, height: height * 0.95)
                    .overlay(
                        RoundedRectangle(cornerRadius: height)
                            .fill(.blue.opacity(1.0))
                            .frame(width: width * 0.85, height: height * 0.85)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: height)
                            .stroke(.green, lineWidth: 8)
                    )
            )
    }
}

struct DrawBorderAroundRoundedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        DrawBorderAroundRoundedRectangle()
    }
}
