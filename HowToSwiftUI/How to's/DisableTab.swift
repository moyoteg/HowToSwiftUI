//
//  DisableTab.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/10/21.
//

import SwiftUI
import Introspect

struct DisableTab: View {
        
    var body: some View {
        TabView {
            Text("Enabled Tab")
                .tabItem {
                    Text("enabled tab")
                        Image(systemName: "eye")
                }
            
            Text("Disabled Tab")
                .tabItem {
                    Text("Disabled tab")
                        Image(systemName: "eye.slash")
                }
        }
        .introspectTabBarController { (tabController) in
            let tabItem = tabController.tabBar.items?[1]
            tabItem?.isEnabled = false
        }
    }
}
