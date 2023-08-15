//
//  SectionFullHeaderImage.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 6/12/23.
//

import SwiftUI

struct SectionFullHeaderImage: View {
    
    var body: some View {
        
        NavigationStack {
            
            List {
                Section {
                    NavigationLink(destination:
                                    
                                    VStack {
                        
                        Image("Sample")
                            .scaledToFill()
                            .frame(height: 200)
                        
                        NavigationStack {
                            
                            List {
                                Section {
                                    NavigationLink(destination: Text("Hello")) {
                                        
                                        
                                    }
                                }
                            }
                            .toolbar {
                                Text("hello")
                            }
                            
                        }
                    }
                                   
                    ) {
                        Text("Hello")
                    }
                }
            }
            
        }    }
}

struct SectionFullHeaderImage_Previews: PreviewProvider {
    static var previews: some View {
        SectionFullHeaderImage()
    }
}
