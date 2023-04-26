//
//  CreateHorizontalSections.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/25/23.
//

import SwiftUI

//  SectionList.swift
//  SwiftUIListExample
//
//  Created by John Doe on 4/26/23.
//

import SwiftUI

struct CreateHorizontalSections: View {
    
    var sections = ["Section 1", "Section 2", "Section 3"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sections, id: \.self) { section in
                    Section(header: Text(section)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(1...7, id: \.self) { index in
                                    NavigationLink(destination: DetailView(sectionName: section, index: index)) {
                                        SectionCell(index: index)
                                            .frame(width: 150, height: 200)
                                            .cornerRadius(10)
                                            .padding()
                                    }
                                }
                            }
                        }
                        .frame(height: 250)
                    }
                }
            }
            .navigationBarTitle("Sections")
        }
    }
    
    struct SectionCell: View {
        var index: Int
        
        var body: some View {
            VStack {
                Image("quest\(index)")
                    .resizable()
                    .scaledToFit()
                
                Text("Cell \(index)")
                    .font(.headline)
            }
        }
    }

    struct DetailView: View {
        var sectionName: String
        var index: Int
        
        var body: some View {
            VStack {
                Text("Section: \(sectionName)")
                    .font(.title)
                
                Spacer()
                
                Image("image\(index)")
                    .resizable()
                    .scaledToFit()
                
                Text("Cell \(index)")
                    .font(.headline)
                
                Spacer()
            }
            .padding()
        }
    }
}


struct CreateHorizontalSections_Previews: PreviewProvider {
    static var previews: some View {
        CreateHorizontalSections()
    }
}
