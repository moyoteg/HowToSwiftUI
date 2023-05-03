//
//  SelectAppIcon.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/25/23.
//

import SwiftUI

import CloudyLogs
import SwiftUIComponents

struct SelectAppIcon: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack {
            Text("Select an app icon:")
                .font(.headline)
                .padding()
            
            Picker(selection: $selectedIndex, label: Text("")) {
                ForEach(0..<AppIcon.allCases.count, id: \.self) { index in
                    AppIcon.allCases[index].image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            
            Button("Set App Icon") {
                AppIcon.allCases[selectedIndex].setAsAppIcon()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

enum AppIcon: String, CaseIterable {
    case icon1 = "AppIcon1"
    case icon2 = "AppIcon2"
    case icon3 = "AppIcon3"
    
    var image: Image {
        if let uiimage = UIImage(named: self.rawValue) {
            return Image(uiImage: uiimage)
        } else {
            return SwiftUI.Image(systemName: "circle.slash")
        }
    }
    
    func setAsAppIcon() {
        UIApplication.shared.setAlternateIconName(rawValue) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success!")
            }
        }
    }
}

struct SelectAppIcon_Previews: PreviewProvider {
    static var previews: some View {
        SelectAppIcon()
    }
}
