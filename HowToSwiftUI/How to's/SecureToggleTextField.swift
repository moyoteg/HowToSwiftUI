//
//  SecureToggleTextField.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/5/21.
//

import SwiftUI
import Introspect

struct SecureToggleTextField: View {
    
    @State var text: String = "some secret text"
    
    var body: some View {
        SecureField("placeholder", text: $text)
            .padding()
            .modifier(SecureToggle())
    }
}

struct SecureToggle: ViewModifier {

        @State public var isSecure: Bool = true
        
        public func body(content: Content) -> some View {
            
            HStack {
                content
                    .introspectTextField { (textfield) in
                        textfield.isSecureTextEntry = isSecure
                    }
                
                Spacer()
                
                Button(action: {
                    self.isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash":"eye")
                }
                .padding()
            }
        }
        
    }
