//
//  View3DObject.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/27/23.
//

import SceneKit
import SwiftUI

struct View3DObject: UIViewRepresentable {
    class Coordinator: NSObject {
        let scene = SCNScene(named: "bitcoin_logo.scn")!

        lazy var cameraNode: SCNNode = {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 30, y: 30, z: 30)
            return cameraNode
        }()

        lazy var lightNode: SCNNode = {
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
            return lightNode
        }()

        lazy var coinNode: SCNNode = {
            let coinNode = scene.rootNode.childNode(withName: "root", recursively: true)!
//            coinNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi/4) // rotate around the x-axis by pi/4 radians
//
//            // Set pivot point at center of coinNode
//            let boundingBox = coinNode.boundingBox
//            let pivot = SCNMatrix4MakeTranslation(
//                (boundingBox.max.x - boundingBox.min.x) / 2 + boundingBox.min.x,
//                (boundingBox.max.y - boundingBox.min.y) / 2 + boundingBox.min.y,
//                (boundingBox.max.z - boundingBox.min.z) / 2 + boundingBox.min.z
//            )
//            coinNode.pivot = pivot
            
            return coinNode
        }()

        func animateCoin() {
            let rotateAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(x: 0, y: 1, z: 0), duration: 20) // rotate around the y-axis
            coinNode.runAction(SCNAction.repeatForever(rotateAction))
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView(frame: .zero)
        sceneView.scene = context.coordinator.scene
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene?.rootNode.addChildNode(context.coordinator.cameraNode)
        sceneView.scene?.rootNode.addChildNode(context.coordinator.lightNode)
        sceneView.scene?.rootNode.addChildNode(context.coordinator.coinNode)
        context.coordinator.animateCoin()
        
        // Add look-at constraint to keep coin centered to camera
        let constraint = SCNLookAtConstraint(target: context.coordinator.coinNode)
        context.coordinator.cameraNode.constraints = [constraint]
        
        // Add camera look-at to keep coin centered in view
        context.coordinator.cameraNode.look(at: context.coordinator.coinNode.worldPosition)
        
        return sceneView
    }
    
    func updateUIView(_ view: SCNView, context: Context) {}
}
struct View3DObject_Previews: PreviewProvider {
    static var previews: some View {
        View3DObject()
    }
}
