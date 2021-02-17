//
//  HowToShowPopUp.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI

struct ShowPopUP: View {
    
    @State private var isPresented = false
    
    var body: some View {
        VStack {

            PopUp(isPresented: $isPresented) {
                Button("show menu") {
                    withAnimation {
                        isPresented = true
                    }
                }
            } popUpContent: {
                Button("hide menu") {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
    }
}


struct PopUp<Content: View>: View {
    
    @Binding private var isPresented: Bool
    let content: () -> Content
    let popUpContent: () -> Content

    var body: some View {
        ZStack {
            content()
            if isPresented {
                popUpContent()
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
    
    public init(isPresented: Binding<Bool>,
                @ViewBuilder content: @escaping () -> Content,
                @ViewBuilder popUpContent: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
        self.popUpContent = popUpContent
    }
}
