//
//  UseImageAsViewBackground.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 6/30/21.
//

import SwiftUI

struct UseImageAsViewBackground: View {
    
    var body: some View {
        ZStack {
            
            Image("icelandic_sand")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .scaledToFill()
            
            Text("🐮")
                .font(.title)
        }
    }
}

struct UseImageAsViewBackground_Previews: PreviewProvider {
    static var previews: some View {
        UseImageAsViewBackground()
    }
}
