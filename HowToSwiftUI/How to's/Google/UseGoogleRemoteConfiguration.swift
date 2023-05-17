//
//  GoogleRemoteConfiguration.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/11/23.
//

import SwiftUI

import SwiftUIComponents

struct UseGoogleRemoteConfiguration: View {
    var body: some View {
        RemoteConfigurationView()
    }
}

import MapKit

import FirebaseRemoteConfig

struct RemoteConfiguration {
    
    /*
     ****************************************************************************************************************
     ****************************************************************************************************************
     ****************************************************************************************************************
     to VIEW current values or UPDATE them gor here: https://console.firebase.google.com/project/nikola-motor/config
     ****************************************************************************************************************
     ****************************************************************************************************************
     ****************************************************************************************************************
     */
    
    static let configuration = RemoteConfig.remoteConfig()
    
    enum Key: String, CaseIterable {
        /* TODO: add all cases to remote config firebase: https://console.firebase.google.com/u/0/project/nikola-motor/config
         
         TODO: add programatic remote config
         https://firebase.google.com/docs/remote-config/automate-rc
         */
        
        enum KeyType {
            case json
            case number
            case bool
            case string
        }
        
        /// **********************************
        /// Remote Configuration Settings
        
        // TODO: add all to firebase ⚠️
        case enableDebugTapCount
        
        case defaultScheduledJobPeriodSeconds
        
        case defaultRegion
        case defaultSpan
        case vehicleSpan
        
        case iOS_EULA_URL
        case iOS_help_URL
        case terms_of_use_URL
        
        // FEATURE FLAG
        case enableBiometricAccess
        case enableDemoLogin
        case enableShowIsAppStoreVersion
        
        case minimumFirebaseFetchTimeIntervalSeconds_release
        case minimumFirebaseFetchTimeIntervalSeconds_development
        
        // ADDED TO FIREBASE ✅
        // ...
        
        
        var keyType: KeyType {
            switch self {
            case .enableDebugTapCount: return KeyType.number
                
            case .defaultScheduledJobPeriodSeconds: return KeyType.number
                
            case .defaultRegion: return KeyType.number
            case .defaultSpan: return KeyType.number
            case .vehicleSpan: return KeyType.number
                
            case .iOS_EULA_URL: return KeyType.string
            case .iOS_help_URL: return KeyType.string
            case .terms_of_use_URL: return KeyType.string
                
            case .enableBiometricAccess: return KeyType.bool
            case .enableDemoLogin: return KeyType.bool
            case .enableShowIsAppStoreVersion: return KeyType.bool
            case .minimumFirebaseFetchTimeIntervalSeconds_release: return KeyType.number
            case .minimumFirebaseFetchTimeIntervalSeconds_development: return KeyType.number
            }
        }
        
        var expectedType: Any.Type {
            switch self {
            case .enableDebugTapCount: return Int.self
                
            case .defaultScheduledJobPeriodSeconds: return Double.self
                
            case .defaultRegion: return Double.self
            case .defaultSpan: return Double.self
            case .vehicleSpan: return Double.self
                
            case .iOS_EULA_URL: return URL.self
            case .iOS_help_URL: return URL.self
            case .terms_of_use_URL: return URL.self
                
            case .enableBiometricAccess: return Bool.self
            case .enableDemoLogin: return Bool.self
            case .enableShowIsAppStoreVersion: return Bool.self
            case .minimumFirebaseFetchTimeIntervalSeconds_release: return Double.self
            case .minimumFirebaseFetchTimeIntervalSeconds_development: return Double.self
            }
        }
        
        var defaultValue: Any {
            switch self {
            case .enableDebugTapCount: return Policy.enableDebugTapCount
                
            case .defaultScheduledJobPeriodSeconds: return Policy.defaultScheduledJobPeriodSeconds
                
            case .defaultRegion: return Policy.defaultRegion
            case .defaultSpan: return Policy.defaultSpan
            case .vehicleSpan: return Policy.vehicleSpan
                
            case .iOS_EULA_URL: return Policy.iOS_EULA_URL
            case .iOS_help_URL: return Policy.iOS_help_URL
            case .terms_of_use_URL: return Policy.terms_of_use_URL
                
            case .enableBiometricAccess: return Feature.optionalBiometricAccess.isEnabled
            case .enableDemoLogin: return Feature.demoLogin.isEnabled
            case .enableShowIsAppStoreVersion: return Feature.showIsAppStoreVersion.isEnabled
            case .minimumFirebaseFetchTimeIntervalSeconds_release: return Policy.minimumFirebaseFetchTimeIntervalSeconds_release
            case .minimumFirebaseFetchTimeIntervalSeconds_development: return Policy.minimumFirebaseFetchTimeIntervalSeconds_development
            }
        }
        
        private var valueType: Any? {
            
            let value = RemoteConfiguration
                .configuration
                .configValue(forKey: rawValue)
            switch keyType {
            case .number: return value.numberValue
            case .string: return value.stringValue
            case .bool: return value.boolValue
            case .json: return value.jsonValue
            }
        }
        
        public var value: Any {
            
            switch valueType {
            case .none:return defaultValue
            case .some(let value):
                switch keyType {
                case .number:
                    if Swift.Int.self == expectedType {
                        return Int(value as! Double)
                    } else {
                        return value as! Double
                    }
                case .string:
                    if URL.self == expectedType {
                        return getURL(
                            key: self.rawValue,
                            defaultValue: Policy.consumer_site_URL)
                    } else {
                        return value as! String
                    }
                case .bool: return value as! Bool
                    // TODO: add JSON support
                case .json: return value as! [String:Any]
                }
            }
        }
    }
    
    // MARK: - Functions
    public static func setupRemoteConfigDefaults() {
        
        var defaults = [String:NSObject]()
        
        for key in Key.allCases {
            defaults[key.rawValue] = key.defaultValue as? NSObject
        }
        
        
            RemoteConfiguration
            .configuration
            .setDefaults(defaults)
    }
    
    static func getURL(key: String, defaultValue: String) -> URL {
        guard let urlString =
            RemoteConfiguration
            .configuration
            .configValue(forKey: key).stringValue,
              urlString.count > 0 else {
            return URL(string: defaultValue)!
        }
        return URL(string: urlString)!
    }
}


// MARK: - View

struct RemoteConfigurationView: View {
    
    public var body: some View {
        NavigationView {
            
            Form {
                
                ForEach(RemoteConfiguration.Key.allCases, id: \.self) {
                    Text("\($0.rawValue): \(String(describing: $0.value))")
                        .font(.caption)
                    
                }
            }
            .navigationBarTitle(Text("Remote Configuration"), displayMode: .automatic)
            .accentColor(Color.lightBlue)
        }
        .listStyle(GroupedListStyle())
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.lightBlue)
    }
}


struct GoogleRemoteConfiguration_Previews: PreviewProvider {
    static var previews: some View {
        UseGoogleRemoteConfiguration()
    }
}


struct Policy {
    
    // Language
    public static let defaultLanguage: Assets.Text.Language = .english
    
    // Debug
    public static let enableDebugTapCount = 3
    
    // Jobs
    public static let periodicNikolaBluetoothAutoconnectJobTimeInterval = 5.0 // seconds
    public static let periodicUpdateUnitsKeysJobTimeInterval = 10.0 // seconds
    public static let periodicGetUnitStateJobTimeInterval = 5.0 // seconds
    public static let periodicIsSelectedUnitDataStaleJobTimeInterval = 5.0 // seconds
    public static let periodicStaleCloudServiceAvailabilityJobTimeInterval = 5.0 // seconds
    public static let periodicStaleTruckBLEAvailabilityJobTimeInterval = 5.0 // seconds
    public static let periodicFetchRemoteConfigJobTimeInterval = 10.0 // seconds
    public static let periodicNikolaGetCurrentSelectedUnitLocationJobTimeInterval = 5.0 // seconds
    public static let periodicFleetInfoUpdateJobTimeInterval = 5.0 // seconds
    public static let periodicNikolaBluetoothConnectionSignalStrengthJobTimeInterval = 1.0 // seconds
    
    // Communication
    public static let communcationRetryPeriodSeconds = 1 // seconds
    
    // Unit
    public static let staleVehicledataPeriodSeconds = 10.0 // seconds
    public static let staleVehicleLocationPeriodSeconds = 10.0 // seconds
    
    // Cloud
    public static let staleCloudServiceAvailabilityTimeIntervalSeconds = 5.0 // seconds
    
    // Bluetooth
    public static let staleBluetoothTruckStateAvailabilityTimeIntervalSeconds = 5.0 // seconds
    
    // Truck
    public static let staleTruckBLEStateAvailabilityTimeIntervalSeconds = 10.0 // seconds
    
    // ScheduledJobs
    public static let defaultScheduledJobPeriodSeconds = 5.0
    
    // Location
    public static let timeToWaitToRecenterSeconds = 5
    public static let defaultCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: -95.7129)
    public static let defaultRegion = MKCoordinateRegion(center: defaultCoordinate, span: defaultSpan)
    public static let defaultSpan = MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
    public static let vehicleSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    // Cryptography
    public static let textToSign = "test"
    
    // Message
    public static let nowAndReceivedTimestampTimeIntervalDifferenceTolerance = 5.0
    
    // HVAC
    // Celsius
    public static let HVACTemperatureRangeCelsiusLowerBound = 10.0
    public static let HVACTemperatureRangeCelsiusUpperBound = 30.0
    public static let HVACTemperatureRangeCelsius: ClosedRange<Double> = HVACTemperatureRangeCelsiusLowerBound...HVACTemperatureRangeCelsiusUpperBound
    // Fahrenheit
    public static let HVACTemperatureRangeFahrenheitLowerBound = 50.0
    public static let HVACTemperatureRangeFahrenheitUpperBound = 86.0
    public static let HVACTemperatureRangeFahrenheit: ClosedRange<Double> = HVACTemperatureRangeFahrenheitLowerBound...HVACTemperatureRangeFahrenheitUpperBound
    
    // URLs
    public static let consumer_site_URL = "https://www.nikolamotor.com"
    public static let consumer_site_legal_URL = consumer_site_URL + "/legal"
    public static let iOS_EULA_URL = consumer_site_legal_URL + "/eula/ios"
    public static let iOS_help_URL = consumer_site_URL + "/contact"
    public static let terms_of_use_URL = consumer_site_legal_URL
    
    // Intervails
    public static let minimumFirebaseFetchTimeIntervalSeconds_release = 60*60*12 // 12 hours
    public static let minimumFirebaseFetchTimeIntervalSeconds_development = 10 // seconds
    
    // Biometric Authentication
    public static let biometricAuthenticationExpirationTimeIntervalSeconds: TimeInterval = 60*15 // 15 minutes
    public static let biometricAuthenticationExpirationTimeIntervalSeconds_Testing: TimeInterval = 5 // 5 seconds
    
    // Sample Data
    public static let moyaProviderStubBehaviorDelayTimeIntervalSeconds: TimeInterval = 0.5 // seconds
    public static let defaultMoyaStubBehaviorInmediate = false
    // TODO: never expire cookie?
    public static let sampleDataCookie = "_session_id=09a35089d32790518190f7967d192bc0; path=/; expires=Wed, 10 Aug 2032 07:26:07 GMT; HttpOnly"
    
    // Unit Defaults
    
    public enum Default {
    }
    
    public enum Version {
        case one
    }
    
    // ////////////////////////////////////////////////////////////
    // TODO: implement
    public enum Rule {
        
        // TODO: implement
        case commincationRetryPeriod
    }
    
    public var version: Version
    
    public let rule: Rule
    
    public var valueType: Any {
        
        switch rule {
        case .commincationRetryPeriod: return Double.self
        }
    }
    // ////////////////////////////////////////////////////////////
    
}

enum Feature {
    
    case optionalBiometricAccess
    case demoLogin
    case showIsAppStoreVersion
    
    var isEnabled: Bool {
        switch self {
        case .optionalBiometricAccess: return false
        case .demoLogin: return false
        case .showIsAppStoreVersion: return false
        }
    }
}
