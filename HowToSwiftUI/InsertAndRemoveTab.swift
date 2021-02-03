//
//  InsertAndRemoveTab.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/3/21.
//

import Foundation
import SwiftUI

struct Tab: Identifiable {
    let id = UUID()
    let title: String
    let label: String
    let tag: Int
}

struct InsertAndRemoveTab: View {
    @State private var tabs = [Tab]()
    
    var body: some View {
        NavigationView {
            VStack {
                
                TabView {
                    ForEach(tabs) { tab in
                        Text(tab.title).tabItem { Text(tab.label) }.tag(tab.tag)
                    }
                }
                
            }.navigationTitle("Dynamic Tab Count")
            .toolbar {
                HStack {
                    Button("Add", action: addItem)
                    Button("Remove", action: removeItem)
                        .disabled(tabs.count == 0)
                }
            }
        }
    }
    
    func addItem() {
        tabs.append(Tab(title:"Tab number: \(tabs.count)", label: "Tab Label \(tabs.count)", tag: tabs.count + 1))
    }
    
    func removeItem() {
        tabs.removeLast()
    }
}
