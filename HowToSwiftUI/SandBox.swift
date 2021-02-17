//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI

struct SandBox: View {
    
    @State private var showMenu = false
    
    var body: some View {
        VStack {
            ZStack {
                Button("show menu") {
                    withAnimation {
                        showMenu = true
                    }
                }
                if showMenu {
                    Button("hide menu") {
                        withAnimation {
                            showMenu = false
                        }
                    }
                    .padding()
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(15)
                        
                        , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .transition(.scale)
                    .padding(.top, 16)
                    .shadow(radius: 10)
                }
            }
            
        }
    }
}
