//
//  CoolNavigation.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/23/23.
//

import SwiftUI

import SwiftUIComponents

struct CoolNavigation: View {
    
    let imageResource = ""
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                VStack {
                    
                    AutoImage(imageResource)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer ()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                            Text("title")
                                .font(.title)
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
                                
                                Text(Date().addingTimeInterval(-100000).relativeDateString)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                
                            }
                            
                            Spacer()
                            
                            EmptyView()
                        }
                        .padding(16)
                        
                        HStack {
                            
                            Spacer()
                            
                        }
                    }
                }
            }
        }
    }
}

struct CoolNavigation_Previews: PreviewProvider {
    static var previews: some View {
        CoolNavigation()
    }
}
