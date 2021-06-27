//
//  UseUIKitPageView.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 3/25/21.
//

import SwiftUI
import SwiftUIComponents

struct UseUIKitPageView: View {
    
    @State var currentPage: Int = 0
    @State var isSelecting = false
    
    var body: some View {
        PageView(
            pageCount: .constant(5),
            currentPage: $currentPage,
            isSelecting: $isSelecting) { index in
            
            Text("\(index)")
        }
    }
}
