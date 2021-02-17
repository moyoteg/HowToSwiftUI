//
//  HowToUseSheet.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import Foundation
import SwiftUI

struct UseSheet: View {
    
    @State var showSheet: Bool = false
    
    var body: some View {
    
        Button("sheet") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet, content: {
            Text("Hello World!")
        })
        
    }
}
