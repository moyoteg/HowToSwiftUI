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
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
            }
            .frame(width: 50, height: 50)

//            .pickerStyle(SegmentedPickerStyle())
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
    
    var image: URLImage {
        return URLImage(localImageName: self.rawValue)
    }

    func setAsAppIcon() {
        Logger.log("Tapped icon \(self.rawValue)")
        
        if UIApplication.shared.supportsAlternateIcons {
            // Change icon
            UIApplication.shared.setAlternateIconName(self.rawValue) { error in
                if let error = error {
                    Logger.log("ERROR: Could not set custom icon \(self.rawValue). \(error)")
                    Logger.log(error.localizedDescription)
                }
            }
        } else {
            print("Error: Icon changes not supported")
        }
    }
}

struct SelectAppIcon_Previews: PreviewProvider {
    static var previews: some View {
        SelectAppIcon()
    }
}
