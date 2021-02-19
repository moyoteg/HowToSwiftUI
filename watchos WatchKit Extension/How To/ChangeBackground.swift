//
//  ChangeBackground.swift
//  watchos WatchKit Extension
//
//  Created by Moi Gutierrez on 2/19/21.
//

import SwiftUI

struct ChangeBackground: View {
    
    @State var color: Color = .red
    
    let allColors: [Color] = [
        .clear,
        .black,
        .white,
        .gray,
        .red,
        .green,
        .blue,
        .orange,
        .yellow,
        .pink,
        .purple,
        .primary,
        .secondary,
    ]
    
    var body: some View {
        ZStack {
            color
            Button("change") {
                withAnimation {
                    color = allColors.randomElement()!
                }
            }
            .padding()
        }
    }
    
}
