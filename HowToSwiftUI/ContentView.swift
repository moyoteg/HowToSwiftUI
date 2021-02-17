//
//  ContentView.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    
    let howTos = [
        HowTo("sandbox", AnyView(SandBox())),
        HowTo("hide nav bar", AnyView(HideNavigationBar())),
        HowTo("use sheet", AnyView(UseSheet())),
        HowTo("center text textfield", AnyView(CenterTextFieldPlaceholderText())),
        HowTo("insert and remove tab", AnyView(InsertAndRemoveTab())),
        HowTo("secure toggle textfield", AnyView(SecureToggleTextField())),
        HowTo("(unresolved) disable tab", AnyView(DisableTab())),
        HowTo("insert/remove view with transition", AnyView(InsertAndRemoveViewWithTransition())),
        HowTo("show pop up", AnyView(ShowPopUP())),
        HowTo("pass generic view content", AnyView(PassGenericViewContent()))
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                FilteredList("How To", list: howTos) { (howTo) in
                    NavigationLink(howTo.name, destination: howTo.view)
                }
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


struct HowTo: View, StringFilterable {
    
    var filter: String {
        return name
    }
    
    var description: String {
        return name
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
    
    init(_ name: String, _ view: AnyView) {
        self.name = name
        self.view = view
    }
}
