//
//  PinSectionHeaderToTop.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 10/3/23.
//

import SwiftUI

struct PinSectionHeaderToTop: View {
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders) {
                Section {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(0 ..< 50) { item in
                            Text("\(item)")
                        }
                    }
                    .padding()
                } header: {
                    HStack {
                        Spacer()
                        Text("First Section")
                        Spacer()
                    }
                    .background(.thinMaterial)
                }
            }
            
        }
    }
}

#Preview {
    PinSectionHeaderToTop()
}
