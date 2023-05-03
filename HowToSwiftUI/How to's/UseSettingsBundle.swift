//
//  UseSettingsBundle.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/3/23.
//

import SwiftUI

enum AppStorageKey {
    case username
    case isDarkMode
    case count
    case lastLogin
    case selectedOption
    case stringPreference
    case togglePreference // added case for Toggle preference
    case sliderPreference // added case for Slider preference

    var key: String {
        switch self {
        case .username: return "username"
        case .isDarkMode: return "isDarkMode"
        case .count: return "count"
        case .lastLogin: return "lastLogin"
        case .selectedOption: return "selectedOption"
        case .stringPreference: return "string_preference"
        case .togglePreference: return "toggle_preference" // map case to preference key
        case .sliderPreference: return "slider_preference" // map case to preference key
        }
    }
}

struct UseSettingsBundle: View {
    @AppStorage(AppStorageKey.username.key) var username: String = "Guest"
    @AppStorage(AppStorageKey.isDarkMode.key) var isDarkMode: Bool = false
    @AppStorage(AppStorageKey.count.key) var count: Int = 0
    @AppStorage(AppStorageKey.lastLogin.key) var lastLogin: Double = Date().timeIntervalSinceReferenceDate
    @AppStorage(AppStorageKey.selectedOption.key) var selectedOption: String?
    @AppStorage(AppStorageKey.stringPreference.key) var stringPreference: String = "Default Value"
    @AppStorage(AppStorageKey.togglePreference.key) var togglePreference: Bool = false
    @AppStorage(AppStorageKey.sliderPreference.key) var sliderPreference: Double = 0.5

    var lastLoginDate: Date {
        get {
            Date(timeIntervalSinceReferenceDate: lastLogin)
        }
        set {
            lastLogin = newValue.timeIntervalSinceReferenceDate
        }
    }

    var body: some View {
        
        let selectedOptionBinding = Binding<String>(
            get: { selectedOption ?? "" },
            set: { selectedOption = $0.isEmpty ? nil : $0 }
        )
        
        Form {
            
            Section {
                Text("String Preference: \(stringPreference)")
                Toggle("Toggle Preference", isOn: $togglePreference)
                Slider(value: $sliderPreference, in: 0...1)
            } header: {
                Text("Types")
            } footer: {
                VStack {
                    Text(
                        "These settings are also found in the \"Settings\" app."
                    )
                    Link(
                        "Open Settings",
                        destination: URL(string: UIApplication.openSettingsURLString)!
                    )
                }
            }

            Section("Examples") {
                Text("Welcome, \(username)!")
                Toggle("Dark Mode", isOn: $isDarkMode)
                Text("Count: \(count)")
                Text("Last login: \(lastLoginDate, formatter: dateFormatter)")
                TextField("Enter option", text: selectedOptionBinding)
            }
        }
        .padding()
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
