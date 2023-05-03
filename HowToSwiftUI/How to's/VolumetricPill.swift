//
//  VolumetricPill.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/28/22.
//

import SwiftUI

import SwiftUIComponents
import SwiftUtilities

struct VolumetricPill: View {
    
    let height = 100.0
    let width = 150.0
    
    @State var percentage: Double = 0

    var currentWidth: Double {
        width * percentage/100
    }
    
    var body: some View {
        
        Text("currentWidth: \(String(format: "%.0f", currentWidth))")

        GeometryReader { geometry in

            ZStack {
                
                // blue shadow background
                RoundedRectangle(cornerRadius: geometry.size.height)
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(.blue.opacity(0.5))
                    .brightness(-0.3)
                    .opacity(0.8)
                    .shadow(color: .blue, radius: 16)
                
                // Pill
                ZStack(alignment: .leading) {
                    
                    // fuel progress bar
                    RoundedRectangle(cornerRadius: geometry.size.height)
                        .overlay(
                            
                            // inner fuel progress bar
                            RoundedRectangle(cornerRadius: geometry.size.height)
                                .fill(.blue)
                                .overlay(
                                    // inner INNER fuel progress bar
                                    RoundedRectangle(cornerRadius: geometry.size.height)
                                        .stroke(Color.lightBlue, lineWidth: 6)
                                        .opacity(0.6)
                                )
                        )
                        .padding(8)
                        .mask(
                            HStack {
                                
                                RoundedRectangle(cornerRadius: geometry.size.height)
                                    .frame(width: CGFloat(self.percentage / 100.0) * geometry.size.width, height: geometry.size.height)
                                
                                Spacer(minLength: 0)
                            }
                        )
                        .animation(.easeInOut, value: "roundedAnimation")

                    // top white frame
                    RoundedRectangle(cornerRadius: geometry.size.height)
                        .stroke(.white, lineWidth: 2)
                        .frame(width: geometry.size.width , height: geometry.size.height)
                }
                
            }

        }
        .frame(height: height)
        .padding()
        
        Group {
            Text("\(String(format: "%.0f", percentage))%")
            Slider(value: $percentage, in: 0...100, step: 1.0)
                .padding()
        }
    }
    
    /*
     {
         
         GeometryReader { geometry in
         
             ZStack {
                 
                 // blue shadow background
                 RoundedRectangle(cornerRadius: geometry.size.height)
                     .frame(width: geometry.size.width , height: geometry.size.height)
                     .foregroundColor(Color.Nikola.lightBlue.opacity(0.5))
                     .brightness(-0.3)
                     .opacity(0.8)
                     .shadow(color: Color.Nikola.lightBlue, radius: 16)
                 
                 // Pill
                 ZStack(alignment: .leading) {
                     
                     // fuel progress bar
                     RoundedRectangle(cornerRadius: geometry.size.height)
                         .overlay(
                             
                             // inner fuel progress bar
                             RoundedRectangle(cornerRadius: geometry.size.height)
                                 .fill(Color.Nikola.lightBlue)
                                 .overlay(
                                     // inner INNER fuel progress bar
                                     RoundedRectangle(cornerRadius: geometry.size.height)
                                         .stroke(Color.Nikola.lightBlue, lineWidth: 6)
                                         .opacity(0.6)
                                 )
                         )
                         .padding(8)
                         .mask(
                             HStack {
                                 
                                 RoundedRectangle(cornerRadius: geometry.size.height)
                                     .frame(width: CGFloat(self.percentage / 100.0) * geometry.size.width, height: geometry.size.height)
                                 
                                 Spacer(minLength: 0)
                             }
                         )
 //                        .mask(
 //                            HStack {
 //
 //                                RoundedRectangle(cornerRadius: 0)
 //                                    .frame(width: CGFloat(self.percentage / 100.0) * geometry.size.width, height: geometry.size.height)
 //
 //                                Spacer(minLength: 0)
 //                            }
 //                        )
 //                        .overlay(
 //
 //                            HStack(spacing: 0) {
 //
 //                                // invisible rectangle to help position line
 //                                Rectangle()
 //                                    .fill(.clear)
 //                                    .frame(width: CGFloat(self.percentage / 100.0) * geometry.size.width, height: geometry.size.height)
 //
 //                                // line
 ////                                Rectangle()
 ////                                    .stroke(Color.Nikola.white, lineWidth: 1)
 ////                                    .frame(width: 1)
 //
 //                                // to push views to the left
 //                                Spacer(minLength: 0)
 //                            }
 //                        )
                         .animation(.easeInOut)

                     // top white frame
                     RoundedRectangle(cornerRadius: geometry.size.height)
                         .stroke(Color.Nikola.white, lineWidth: 2)
                         .frame(width: geometry.size.width , height: geometry.size.height)
                     // .hydrogenAnimation()
                 }
             }
         }
     }
     */
}

struct VolumetricPill_Previews: PreviewProvider {
    static var previews: some View {
        VolumetricPill()
    }
}
