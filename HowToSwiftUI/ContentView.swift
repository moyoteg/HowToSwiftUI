//
//  ContentView.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        NavigationView {
            List {
                NavigationLink("hide nav bar", destination: HideNavigationBar())
                NavigationLink("use sheet", destination: UseSheet())
                NavigationLink("center text textfield", destination: CenterTextFieldPlaceholderText())
                NavigationLink("insert and remove tab", destination: InsertAndRemoveTab())
                NavigationLink("secure toggle textfield", destination: SecureToggleTextField())
            }
            .navigationTitle("How to")
        }
            Divider()
            VStack {
                Text("by ") +
                Text("Moi Gutiérrez")
                    .font(.system(size: 18, weight: .bold, design: .default)) +
                Text(" with love ❤️")
                Link("@moyoteg",
                      destination: URL(string: "https://www.twitter.com/moyoteg")!)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
