//
//  File.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/18/21.
//

import SwiftUI

struct ScrollRotatingCards: View {
    
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.1)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 10.0) {
                        ForEach(colors) { color in
                            GeometryReader { geometry2 in
                                VStack {
                                    ZStack {
                                        Rectangle()
                                            .fill(color)
                                            .cornerRadius(15)
                                            .padding()
                                        Image(systemName: "bus")
                                            .font(.system(size: 120))
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                }
                                .shadow(color: color, radius: 5)
                                .rotation3DEffect(Angle(degrees: getOffset(geometry: geometry2)), axis: (x: 0, y: 100, z: 0))
                            }
                            .frame(width: geometry.size.width * 0.8,
                                   height: geometry.size.height / 3,
                                   alignment: .center)
                        }
                    }
                }
            }
        }
    }
    
    func getOffset(geometry: GeometryProxy) -> Double {
        Double(geometry.frame(in: .global).minX) * -0.05
    }
}
