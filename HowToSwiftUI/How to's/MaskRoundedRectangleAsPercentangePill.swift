//
//  MaskRoundedRectangleAsPercentangePill.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/22/22.
//

import SwiftUI

struct MaskRoundedRectangleAsPercentangePill: View {
    
    let height = 100.0
    let width = 150.0
    
    @State var percentage: Double = 0

    var currentWidth: Double {
        width * percentage/100
    }

    var body: some View {

        Text("currentWidth: \(String(format: "%.0f", currentWidth))")

        RoundedRectangle(cornerRadius: height)
            .fill(.blue)
            .frame(width: width, height: height)
            .mask(
                HStack {
                    
                    Rectangle()
                        .frame(width: currentWidth, height: height)
                    
                    Spacer(minLength: 0)
                }
            )
            .shadow(radius: 4)
        
        Group {
            Text("\(String(format: "%.0f", percentage))%")
            Slider(value: $percentage, in: 0...100, step: 1.0)
                .padding()
        }
    }
}

struct MaskRoundedRectangleAsPercentangePill_Previews: PreviewProvider {
    static var previews: some View {
        MaskRoundedRectangleAsPercentangePill()
    }
}
