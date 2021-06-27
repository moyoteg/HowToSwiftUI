//
//  CurlPage.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/25/21.
//

import UIKit
import SwiftUI
import SwiftUIComponents
import SwiftUtilities

struct CurlPage: View {
    
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple] {
        didSet {
            pageCount = colors.count
        }
    }
    var symbols = ["car", "pencil", "bus", "star", "waveform.path.ecg.rectangle"]
    
    @State var currentPage: Int = 0
    @State var pageCount: Int = 5
    @State var isSelecting = false

    var body: some View {
        PageView(pageCount: $pageCount,
                 currentPage: $currentPage,
                 isSelecting: $isSelecting,
                 transitionStyle: .pageCurl,
                 navigationOrientation: .horizontal,
                 content: { (index) in
                    ZStack {
                        colors[index]
                        VStack {
                            Image(systemName: symbols[index])
                                .font(.system(size: 120))
                                .foregroundColor(colors[circular: index + 1])
                            Divider()
                            Text("\(index)")
                                .font(.system(size: 120))
                                .foregroundColor(colors[circular: index + 3])
                        }
                    }
                 })
    }
    
}
