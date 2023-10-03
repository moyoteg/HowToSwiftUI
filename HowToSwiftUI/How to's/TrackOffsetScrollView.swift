//
//  TrackOffsetScrollView.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 10/2/23.
//

import SwiftUI

import SwiftUIComponents

struct TrackOffsetScrollView: View {
    @State var scrollOffset = CGFloat.zero
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack {
                    Text( scrollOffset > 100 ? "small detail" : "Large detail")
                        .font(scrollOffset > 100 ? .headline : .title2)
                    
                    if scrollOffset < 50  {
                        Text("more")
                    }
                }
                .animation(.default, value: scrollOffset)
                .frame(height: max(50, 100 - max(scrollOffset, 0)))
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                
                ObservableScrollView(scrollOffset: $scrollOffset) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(0 ..< 50) { item in
                            Text("\(item)")
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Scroll offset: \(scrollOffset)",
                                displayMode: .inline)
        }
    }
}
