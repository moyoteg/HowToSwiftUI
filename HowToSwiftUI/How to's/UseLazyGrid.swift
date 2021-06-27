//
//  UseLazyGrid.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 6/25/21.
//

import SwiftUI

struct UseLazyGrid: View {
    let data = (0...99).map { "Item \($0)" }

    @State var sections = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        
        VStack {
            HStack {
                Button("add section") {
                    withAnimation {
                        sections.append(GridItem(.flexible()))
                    }
                }
                .padding()
                                
                Button("remove section") {
                    withAnimation {
                        if sections.isEmpty { return }
                        sections.removeLast()
                    }
                }
                .padding()
            }
            
            Divider()
            
            Text("LazyVGrid")
                .font(.title2)
            
            ScrollView {
                LazyVGrid(columns: sections, spacing: 20) {
                    ForEach(data, id: \.self) { item in
                        Text(item)
                    }
                }
                
            }
            .padding()
            
            Divider()
            
            Text("LazyHGrid")
                .font(.title2)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: sections, spacing: 20) {
                    ForEach(data, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .padding()
        }
    }
}
