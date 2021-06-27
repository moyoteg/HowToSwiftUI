//
//  UseLazyGrid.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 6/25/21.
//

import SwiftUI

struct UseLazyGrid: View {
    let data = (1...100).map { "Item \($0)" }

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
                Spacer()
                Button("add section") {
                    withAnimation {
                        sections.append(GridItem(.flexible()))
                    }
                }
                .padding()
                
                Spacer()
                
                Button("remove section") {
                    withAnimation {
                        if sections.isEmpty { return }
                        sections.removeLast()
                    }
                }
                .padding()
                Spacer()
            }
            
            ScrollView {
                LazyVGrid(columns: sections, spacing: 20) {
                    ForEach(data, id: \.self) { item in
                        Text(item)
                    }
                }
                
            }
            .padding()
            
            Divider()
            
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
