//
//  HowTo.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/19/21.
//

import SwiftUI
import SwiftUIComponents

struct HowTo: View, StringFilterable, Identifiable {
    
    var id: String {
        return name
    }
    
    var filter: String {
        return name
    }
    
    var description: String {
        return "\(isResolved ? "✅":"❌") " + name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: HowTo, rhs: HowTo) -> Bool {
        lhs.name == rhs.name
    }
    
    let name: String
    var view: AnyView
    var body: some View {
        view
    }
    let isResolved: Bool
    
    init(isResolved: Bool = false, _ name: String, _ view: AnyView) {
        self.name = name
        self.view = view
        self.isResolved = isResolved
    }
}
