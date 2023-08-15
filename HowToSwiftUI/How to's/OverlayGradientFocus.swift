//
//  OverlayGradientFocus.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 8/14/23.
//

import SwiftUI

import SwiftUIComponents

struct OverlayGradientFocus: View {
    var body: some View {

        HStack {
            
            view()
            
            view()
                .overlayGradientFocus(position: .top)
            
            view()
                .overlayGradientFocus(position: .center)
            
            view()
                .overlayGradientFocus(position: .bottom)
        }
        .background(.red)
    }
    
    @ViewBuilder
    func view() -> some View {
        
        //        Image(imageName)
        //        .resizable()
        //        .aspectRatio(contentMode: .fit)
        
        Color.green
    }
}

struct OverlayGradientFocus_Previews: PreviewProvider {
    static var previews: some View {
        OverlayGradientFocus()
    }
}
