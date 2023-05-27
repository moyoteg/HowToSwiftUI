//
//  CreateFlowLayout.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/27/23.
//

import SwiftUI

import Flow

struct CreateFlowLayout: View {
    
    let range = 1...3
    
    @State var percentage: Double = 0

    public var body: some View {
        
            
            ScrollView {

                GeometryReader { geo in

                HFlow(alignment: .center) {
                    
                    ForEach(range, id: \.self) { count in


                        Rectangle()
                            .fill(.blue)
                            .frame(width: geo.size.width * (count == range.last && range.count % 2 != 0 ? 1.0:0.49), height: geo.size.width)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                Text("\(count)")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                        
                    }
                }
            }
        }
        
        VStack {
            GeometryReader { geo in
                
                ScrollView {
                    
                    HFlow(alignment: .center) {
                        
                        ForEach(range, id: \.self) { count in
                            
                            let isUneven = range.count % 2 != 0
                            let isLastAndUneven = count == range.last && isUneven
                            
                            Rectangle()
                                .fill(.blue)
                                .frame(width: isLastAndUneven ? geo.size.width:(geo.size.width * percentage / 2) ,height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    Text("\(count)")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                        }
                    }
                }
                
            }
            
            Slider(value: $percentage, in: 0...1, step: 0.01)
        }
        .padding()
    }
}

struct CreateFlowLayout_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlowLayout()
    }
}
