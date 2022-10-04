//
//  RequestAllPermissions.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 8/25/22.
//

import SwiftUI

import SwiftUIComponents

// Permissions
import PermissionsKit
import NotificationPermission
import BluetoothPermission
import FaceIDPermission
import CameraPermission
import PhotoLibraryPermission
import NotificationPermission
import MicrophonePermission
import CalendarPermission
import ContactsPermission
import RemindersPermission
import SpeechRecognizerPermission
import LocationWhenInUsePermission
import LocationAlwaysPermission
import MotionPermission
import MediaLibraryPermission
import BluetoothPermission
import TrackingPermission
import FaceIDPermission
import SiriPermission
import HealthPermission

struct RequestAllPermissions: View {
    
    @State private var isPresented = false

    public var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(SwiftUIComponents.Permission.allCases, id: \.self) { permission in
                    
                    HStack {
                        
                        Text("\(permission.name)")
                        
                        Spacer()
                        
                        Text("\(permission.status.description)")
                        
                        Spacer()
                        
                        Button("request") {
                            withAnimation {
                                                                
                                permission.request {
                                    
                                    isPresented = true
                                    
                                }
                            }
                        }
                        .alert(isPresented: $isPresented) {
                            
                            if permission.isAuthorized {
                                
                                return Alert(
                                    title: Text("\(permission.name) permission"),
                                    message: Text("authorized: \(permission.isAuthorized.description)")
                                )
                                
                            } else {
                             
                                return Alert(
                                    title: Text("\(permission.name) permission"),
                                    message: Text("authorized: \(permission.status.description)"),
                                    primaryButton: .default(
                                        Text("Go To Settings"),
                                        action: {
                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                        }
                                    ),
                                    secondaryButton: .destructive(
                                        Text("Dismiss"),
                                        action: {
                                            
                                        }
                                    )
                                )
                            }
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Permissions"), displayMode: .automatic)
        }
        .listStyle(GroupedListStyle())
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct RequestAllPermissions_Previews: PreviewProvider {
    static var previews: some View {
        RequestAllPermissions()
    }
}
