//
//  ReflectView.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/18/21.
//

import SwiftUI
import SwiftUIComponents

struct ReflectView: View {
    
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple]
    
    @State var direction: ReflectDirection = .bottom
    
    var body: some View {
        VStack {
            Button("change direction") {
                withAnimation {
                    direction.next()
                }
            }
            ZStack {
                Color.black
                
                VStack(alignment: .center, spacing: 15) {
                    ZStack {
                        Rectangle()
                            .fill(colors.randomElement()!)
                            .cornerRadius(15)
                            .padding()
                            .shadow(color: colors.randomElement()!, radius: 5)

                        Image(systemName: "graduationcap")
                            .font(.system(size: 120))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .reflect(direction: direction)
                    .frame(width: 200, height: 150, alignment: .center)
                }
            }
        }
    }
}
