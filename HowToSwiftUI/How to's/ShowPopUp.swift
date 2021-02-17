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

struct PopUp<PopUpContent: View>: ViewModifier {
    
    @Binding private var isPresented: Bool
    let popUpContent: () -> PopUpContent
    let onDismiss: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                popUpContent()
                    .onDisappear {
                        onDismiss?()
                    }
                    .padding()
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(15)
                        
                        , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .transition(.scale)
                    .padding(.top, 42)
                    .shadow(radius: 10)
            }
        }

    }

    
    public init(isPresented: Binding<Bool>,
                onDismiss: (() -> Void)? = nil,
                @ViewBuilder popUpContent: @escaping () -> PopUpContent) {
        self._isPresented = isPresented
        self.onDismiss = onDismiss
        self.popUpContent = popUpContent
    }
}

extension View {
    
    public func popUp<Content>(isPresented: Binding<Bool>,
                               onDismiss: (() -> Void)? = nil,
                               @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content : View {
        self.modifier(PopUp(isPresented: isPresented, onDismiss: onDismiss, popUpContent: content))
    }

}
