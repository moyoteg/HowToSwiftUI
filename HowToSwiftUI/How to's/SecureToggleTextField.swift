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
            .secureToggle(foregroundColor: .green)
    }
}
