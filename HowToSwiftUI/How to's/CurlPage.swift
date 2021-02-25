//
//  CurlPage.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/25/21.
//

import UIKit
import SwiftUI
import SwiftUIComponents
import Utilities

struct CurlPage: View {
    
    @State var currentPage: Int = 0
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple]
    var symbols = ["car", "pencil", "bus", "star", "waveform.path.ecg.rectangle"]

    var body: some View {
        PageView(pageCount: colors.count,
                 currentPage: $currentPage,
                 transitionStyle: .pageCurl,
                 navigationOrientation: .horizontal,
                 content: { (index) in
                    ZStack {
                        colors[index]
                        Image(systemName: symbols[index])
                            .font(.system(size: 120))
                            .foregroundColor(colors[circular: index + 1])
                    }
                 })
    }
    
}
