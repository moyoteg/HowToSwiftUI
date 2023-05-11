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
//                NavigationLink(destination: DetailView()) {
//                    Text("Go to detail view")
//                }
                
                NavigationLink {
                    DetailView()
                } label: {
                    Cell()
//                        .frame(width: 229)
//                        .cornerRadius(20)
                }
                
//                Button {
//                    isActive.toggle()
//                } label: {
//                    Text("Detail View")
//                }
            }
            .navigationTitle("Master View")       
        } detail: {
            DetailView()
            
        }
    }
}

struct Cell: View {
    var body: some View {
        
        ZStack {
            
            Image("quest1")
            
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Text("quest.name")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .padding()
                    
                    Spacer()
                    
                    EmptyView()
                }
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        
                        Text("relativeDateString")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
//                        Skavengerz.UI.Component.GradientText(text: quest.info, size: .custom(size: 16, weight: .semibold))
//                            .font(typography: .secondary(size: .header))
//                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    Spacer()
                    
                    EmptyView()
                }
                .padding(16)
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        // save item
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    .foregroundColor(.white)
                    .padding()
                }
            }
        }
        
        ZStack {
            
            Image(systemName: "bookmark")
            
            Text("Detail View")
                .navigationTitle("Detail")
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
