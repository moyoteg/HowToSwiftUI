//
//  ContentView.swift
//  watchos WatchKit Extension
//
//  Created by Moi Gutierrez on 2/19/21.
//

import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    
    let howTos = [
        HowTo(isResolved: true, "use button", AnyView(UseButton())),
        HowTo(isResolved: true, "change background", AnyView(ChangeBackground())),

    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(footer:
                            VStack {
                                Divider()
                                VStack {
                                    Text("✅ resolved")
                                    Divider()
                                    Text("❌ unresolved")
                                }
                                .fixedSize()
                                Divider()
                                VStack {
                                    Text("by ") +
                                        Text("Moi Gutiérrez")
                                        .font(.system(size: 10, weight: .bold, design: .default)) +
                                        Text(" with ❤️")
                                    Link("@moyoteg",
                                         destination: URL(string: "https://www.twitter.com/moyoteg")!)
                                }
                            }
                        , content: {
                            
                            ForEach(howTos) { (howTo) in
                                NavigationLink(howTo.description,
                                               destination:
                                                howTo.view
                                                .navigationBarTitle("\(howTo.name)")
                                )
                                
                            }
                        })
            }
            .navigationBarTitle("How To")
        }
        .shadow(radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
