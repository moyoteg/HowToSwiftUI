//
//  HowToSwiftUIApp.swift
//  watchos WatchKit Extension
//
//  Created by Moi Gutierrez on 2/19/21.
//

import SwiftUI

@main
struct HowToSwiftUIApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
