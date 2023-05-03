//
//  View3DObject.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/27/23.
//

import SwiftUI
import SceneKit

import CloudyLogs

struct SceneKitView: UIViewRepresentable {
    typealias UIViewType = SCNView
    
    let scene: SCNScene
    var objectNode: SCNNode?
    var cameraNode: SCNNode = SCNNode()
    var lightNode: SCNNode = SCNNode()
    var allowsCameraControl: Bool
    var autoenablesDefaultLighting: Bool
    var backgroundColor: UIColor
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        view.scene = scene
        view.allowsCameraControl = allowsCameraControl
        view.autoenablesDefaultLighting = autoenablesDefaultLighting
        view.backgroundColor = backgroundColor
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        if let objectNode = objectNode {
            scene.rootNode.addChildNode(objectNode)
        }
        return view
    }
    
    func updateUIView(_ view: SCNView, context: Context) {
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        
        if let objectNode = objectNode {
            scene.rootNode.addChildNode(objectNode)
        }
    }
    
    // Helper functions for modifying the view
    
    func objectNode(_ objectNode: SCNNode?) -> SceneKitView {
        var updatedView = self
        updatedView.objectNode = objectNode
        return updatedView
    }
    
    func cameraPosition(x: Float, y: Float, z: Float) -> SceneKitView {
        let updatedView = self
        updatedView.cameraNode.position = SCNVector3(x, y, z)
        return updatedView
    }
    
    func lightPosition(x: Float, y: Float, z: Float) -> SceneKitView {
        let updatedView = self
        updatedView.lightNode.position = SCNVector3(x, y, z)
        return updatedView
    }
    
    func cameraFov(_ fov: CGFloat) -> SceneKitView {
        let updatedView = self
        updatedView.cameraNode.camera?.fieldOfView = fov
        return updatedView
    }
}

struct SceneView: View {

    let fileName: String
    
    let rootNodeName: String
    
    let recusiveRootName: Bool
    
    @State var showControls: Bool
    
    @State private var rotateAnimationEnabled: Bool {
        didSet {
            rotateAnimation()
        }
    }
    
    var scene: SCNScene?
        
    var objectNode: SCNNode? {
        guard let rootNode = scene?.rootNode.childNode(withName: rootNodeName, recursively: recusiveRootName) else {
            return nil
        }
        return rootNode
    }
    
    var body: some View {
        
        if scene != nil {
         
            SceneKitView(
                scene: scene!,
                objectNode: objectNode,
                allowsCameraControl: true,
                autoenablesDefaultLighting: true,
                backgroundColor: .black
            )
            .cameraPosition(x: 0, y: 0, z: 10)
            .lightPosition(x: 0, y: 5, z: 5)
            .cameraFov(60)
            
            if showControls {
                Button(action: {
                    self.rotateAnimationEnabled.toggle()
                }) {
                    Text(rotateAnimationEnabled ? "Stop Rotation" : "Start Rotation")
                }
            }
            
        } else {
            Text("Could Not Load Scene")
        }
    }
    
    public init(fileName: String,
                rootName: String = "root",
                recusiveRootName: Bool = true,
                rotateAnimationEnabled: Bool = false,
                showControls: Bool = false
    ) {
        self.fileName = fileName
        self.rootNodeName = rootName
        self.recusiveRootName = recusiveRootName
        self.rotateAnimationEnabled = rotateAnimationEnabled
        self.showControls = showControls
        scene = SCNScene(named: fileName)
    }
    
    let actionName = "rotate"
    var isRotating: Bool = false {
        didSet {
            Logger.log("\(isRotating)")
        }
    }
    let rotateAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(x: 0, y: 1, z: 0), duration: 20) // rotate around the y-axis
    
    func rotateAnimation() {
        if rotateAnimationEnabled {
            objectNode?.runAction(SCNAction.repeatForever(rotateAction), forKey: actionName)
        } else {
            objectNode?.removeAction(forKey: actionName)
        }
    }
    
    func isRotating(_ enabled: Bool) -> Self {
        rotateAnimationEnabled = enabled
        rotateAnimation()
        return self
    }
}

struct View3DObject: View {
    
    let sceneNames = ["bitcoin_cash_logo.scn", "bitcoin_logo.scn"]
    
    var body: some View {
    
        NavigationStack {
            List {
                ForEach(sceneNames, id: \.self) { sceneName in
                    NavigationLink(
                        destination:
                            
                            SceneView(fileName: sceneName, showControls: true)
                            .isRotating(true)// TODO: not working
                    ) {
                        SceneView(fileName: sceneName)
                    }
                }
            }
        }
    }
}

struct View3DObject_Previews: PreviewProvider {
    static var previews: some View {
        View3DObject()
    }
}

extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
}

extension SCNVector3: Equatable {
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}
