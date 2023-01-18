//
//  UseCamera.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 1/17/23.
//

import SwiftUI

struct UseCamera: View {
    var body: some View {
        CameraView()
    }
}

struct UseCamera_Previews: PreviewProvider {
    static var previews: some View {
        UseCamera()
    }
}


import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

// this code will allow you to access the camera on the device or the photo library if the camera is not available.
// it will show the view controller for the camera, but you will have to handle the logic for saving the captured images or videos.
// you have to make sure that the user gave the permission for the app to access the camera or the photo library before calling this view.
// the code above is just a basic example for the camera view, you have to design the UI and handle the logic for the captured images or videos yourself.
// this code will work on the iPhone simulator as well as on real devices.
