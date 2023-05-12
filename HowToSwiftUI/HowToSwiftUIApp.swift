//
//  HowToSwiftUIApp.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import SwiftUI
import FirebaseCore

@main
struct HowToSwiftUIApp: App {
    
    init() {
        setupAuthentication()
    }
    
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
