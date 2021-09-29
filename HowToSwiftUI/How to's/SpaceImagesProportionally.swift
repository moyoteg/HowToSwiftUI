//
//  SpaceImagesProportionally.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 9/28/21.
//

import SwiftUI

struct SpaceImagesProportionally: View {
    var body: some View {
        
        GeometryReader { geometry in
            HStack(spacing: -6) {
                Image(systemName: "bus.fill")
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
        }
        .fixedSize()
        
    }
}

struct SpaceImagesProportionally_Previews: PreviewProvider {
    static var previews: some View {
        SpaceImagesProportionally()
    }
}
