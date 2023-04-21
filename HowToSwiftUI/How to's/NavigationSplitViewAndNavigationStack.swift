//
//  NavigationSplitViewAndNavigationStack.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/20/23.
//

import SwiftUI

struct NavigationSplitViewAndNavigationStack: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: DetailView()) {
                    Text("Go to detail view")
                }
            }
            .navigationTitle("Master View")       
        } detail: {
            DetailView()
            
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail View")
            .navigationTitle("Detail")
    }
}


struct NavigationSplitViewAndNavigationStack_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitViewAndNavigationStack()
    }
}
