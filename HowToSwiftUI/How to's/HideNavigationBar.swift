//
//  HideNavigationBar.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import Foundation
import SwiftUI

struct HideNavigationBar: View {
    
    @State var hideNavBar = false
    
    var body: some View {
        VStack {
            Button("hideNavbar") {
                hideNavBar.toggle()
            }
            .navigationBarHidden(hideNavBar)
        }
    }
}
