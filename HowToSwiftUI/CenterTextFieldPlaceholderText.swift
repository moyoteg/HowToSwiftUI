//
//  CenterTextFieldPlaceholderText.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import Foundation
import SwiftUI

struct CenterTextFieldPlaceholderText: View {
    
    @State var centerText: Bool = false
    @State var text: String = ""
    
    var body: some View {
    
        VStack {
            TextField("placeholder text", text: $text)
                .padding()
                .multilineTextAlignment(centerText ? TextAlignment.center: TextAlignment.leading)
                .background(Color.black.opacity(0.1))
            Button("center text") {
                centerText.toggle()
            }
        }
        
    }
}
