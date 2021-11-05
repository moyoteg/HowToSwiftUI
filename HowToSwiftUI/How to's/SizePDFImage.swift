//
//  ShowPDFImage.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 11/3/21.
//

import SwiftUI

struct SizePDFImage: View {
    var body: some View {
        VStack {
            Image(systemName: "lock")
                .resizable()
                .frame(width: 150, height: 300, alignment: .center)
            
            Divider()
            
            Image(systemName: "lock")
            
            Divider()
            
            Image(systemName: "lock")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                
            // TODO: figure out how to get proper border width from icon itself
        }
    }
}


struct ShowPDFImage_Previews: PreviewProvider {
    static var previews: some View {
        SizePDFImage()
    }
}
