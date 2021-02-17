//
//  HowToShowPopUp.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI
import SwiftUIComponents

struct ShowPopUP: View {
    
    @State private var isPresented = false
    
    var body: some View {
        VStack {

            Button("show menu") {
                withAnimation {
                    isPresented = true
                }
            }
            .popUp(isPresented: $isPresented,
                   onDismiss: {
                print("on dismiss")
            }) {
                Button("hide menu") {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
    }
}
