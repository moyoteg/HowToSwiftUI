//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI

extension Color: Identifiable {
    public var id: String {
        self.description
    }
}

struct SandBox: View {
    
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.1)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 5.0) {
                        ForEach(colors) { color in
                            GeometryReader { geometry2 in
                                VStack {
                                    ZStack {
                                        Rectangle()
                                            .fill(color)
                                            .cornerRadius(15)
                                            .padding()
                                        Image(systemName: "bus")
                                            .font(.system(size: 120))
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                }
                                .shadow(color: color, radius: 5)
                                .rotation3DEffect(Angle(degrees: getOffset(geometry: geometry2)), axis: (x: 1, y: 1, z: 0.3))
                                
                            }
                            .frame(width: geometry.size.width * 0.8,
                                   height: geometry.size.height / 3,
                                   alignment: .center)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func getOffset(geometry: GeometryProxy) -> Double {
        
        let offset = Double(geometry.frame(in: .global).minX) / -20
        print("\(offset)")
        return offset
    }
}


/*
 //
 //  SandBox.swift
 //  HowToSwiftUI
 //
 //  Created by Moi Gutierrez on 2/16/21.
 //
 
 import SwiftUI
 
 extension Color: Identifiable {
 public var id: String {
 self.description
 }
 }
 
 struct SandBox: View {
 
 var colors = [Color.blue,  Color.pink, Color.green]
 @State private var selectedColor = "Red"
 @State private var isPresented = false
 
 var cardColor: Color = Color.blue
 
 var body: some View {
 ZStack {
 Color.gray.opacity(0.1)
 ScrollView(.horizontal, showsIndicators: false) {
 HStack {
 GeometryReader { geometry2 in
 ForEach(colors) { color in
 Rectangle()
 .fill(color)
 .cornerRadius(15)
 .padding()
 .shadow(color: color.opacity(0.5), radius: 10)
 //                                    .rotation3DEffect(Angle(degrees: Double(geometry2.frame(in: .global).minX)), axis: (x: 10, y: 10, z: 10))
 }
 }
 .frame(width: 100,
 height: 200,
 alignment: .center)
 }
 }
 }
 }
 }
 
 */
