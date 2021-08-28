//
//  CopyText.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 8/18/21.
//

import SwiftUI

struct CopyText: View {
    
    let textToCopy = "copy me!"
    
    var body: some View {
        Text(textToCopy)
            .contextMenu(ContextMenu(menuItems: {
              Button("Copy", action: {
                UIPasteboard.general.string = textToCopy
              })
              .padding()
              .cornerRadius(3.0)
            }))
    }
}

struct CopyText_Previews: PreviewProvider {
    static var previews: some View {
        CopyText()
    }
}
