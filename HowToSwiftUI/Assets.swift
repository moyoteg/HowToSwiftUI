//
//  Assets.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/11/23.
//

import Foundation

import SwiftUIComponents

public struct Assets {
    
    enum Text: String, CaseIterable, StringFilterable {
        
        public enum Language: String, CaseIterable, StringFilterable, Codable {
            
            public var filter: String { description }
            
            public var description: String { rawValue }
            
            // ******************************
            // Add Language here:
            case english
        }
        
        public var filter: String { description }
        
        public var description: String { rawValue }
        
        // ******************************
        // Add text keys here:
        
        // Login
        case username
        case password
        case forgotPassword
        case loginAction
        
        // Tabs
        case home
        case quests
        case prizes
        case friends
        case map
        
        // Informative
        case noInfoAvailable
        case error
        case info
        case failedToLogin
        case requestToResetPasswordFailed
        case send
        case resetPassword
        case working
        case demo
        case full
        case fueling
        case unavailable

        // alerts
        case truckDataUnavailableTitle
        case truckDataUnavailableTitleDescription

        // info
        case about
        case help
        case copyrights2022
        case eula
        case termsOfUse
        case licenses

        case user
        case noUsername
        case unknown

        // Settings
        case generalSettings
        case settingsTittle
        case settingNamePassiveUnlock
        case enablePassiveUnlock
        case logout

        // Biometric Access
        case settingNameBiometricAccess
        case settingNameBiometricAccessInfo
        case requireBiometricAuthentication
        case requireBiometricAuthenticationMessage
        case requireBiometricAuthenticationToChangeSettingMessage
        case enableBiometricAccess
        case authenticationRequired
        case tapToTryAgain
        case openSettings
        case biometricsAreUnavailable
        case biometricsAreUnavailableDescription

        // Actions
        case dismiss
        case enable
        case disable
        case cancel
        case confirm
        case clearData
        case submit

        // Controls
        case lock
        case unlock

        // Phrases
        case areYouSure

        // Profile
        case profile
        
        // Interests
        case selectInterestsText
        case interests
        // ******************************
        
        public func text(language: Language) -> String {
            
            switch language {
            case .english:
                switch self {
                case .username: return "Username"
                case .password: return "Password"
                case .forgotPassword: return "Forgot Password?"
                case .loginAction: return "login"

                case .noInfoAvailable: return "no info available"
                case .error: return "error"
                case .info: return "Info"
                case .failedToLogin: return "failed to login"
                case .requestToResetPasswordFailed: return "Request to \"Reset Password\" Failed. Please try again."
                case .send: return "SEND"
                case .resetPassword: return "Reset Password"
                case .working: return "Working..."
                case .demo: return "Demo"
                case .full: return "full"
                case .fueling: return "Fueling"
                case .unavailable: return "unavailable"

                    // alerts
                case .truckDataUnavailableTitle: return "Unavailable"
                case .truckDataUnavailableTitleDescription: return "No recent vehicle information has been received. Make sure you are connected to the Internet and Bluetooth is enabled. If the issue persists contact your Fleet Manager."

                    // info
                case .about: return "about"
                case .help: return "help"
                case .copyrights2022: return "© 2023 Skavengerz. All rights reserved."
                case .eula: return "EULA"
                case .termsOfUse: return "Terms of Use"
                case .licenses: return "Licenses"

                case .user: return "user"
                case .noUsername: return "No Username"
                case .unknown: return "unknown"
                case .generalSettings: return "General Settings"
                case .settingsTittle: return "Settings"
                case .settingNamePassiveUnlock: return "Passive Unlock"

                    // Actions
                case .enablePassiveUnlock: return "Enable Passive Unlock"
                case .logout: return "Log Out"
                case .dismiss: return "Dismiss"
                case .enable: return "Enable"
                case .disable: return "Disable"
                case .cancel: return "Cancel"
                case .confirm: return "Confirm"
                case .areYouSure: return "Are you sure?"
                case .clearData: return "clear data"
                case .submit: return "submit"
                    
                    // tabs
                case .home: return "Home"
                case .quests: return "Quests"
                case .prizes: return "Prizes"
                case .friends: return "Friends"
                case .map: return "Map"
                    
                    // Controls
                case .lock: return "lock"
                case .unlock: return "unlock"

                    // Biometric Access
                case .requireBiometricAuthentication: return "Enable Biometric Authentication" // "Require Biometric Access"
                case .settingNameBiometricAccess: return "Biometric Authentication"
                case .requireBiometricAuthenticationMessage: return "Used to authenticate user and unlock application."
                case .requireBiometricAuthenticationToChangeSettingMessage: return "Required to change setting."
                case .settingNameBiometricAccessInfo: return "Require Biometric Authentication for access."
                case .enableBiometricAccess: return "required"
                case .authenticationRequired: return "" //"Biometric Authentication Required"
                case .tapToTryAgain: return "Tap to try again"
                case .openSettings: return "open settings"
                case .biometricsAreUnavailable: return "Biometrics Unavailable"
                case .biometricsAreUnavailableDescription: return "biometrics must be enabled in your settings first."

                    // Profile
                case .profile: return "Profile"
                    
                case .selectInterestsText: return "Select three or more categories or interests that sound like you."
                case .interests: return "Interests"
                }
            }
        }
    }
}
