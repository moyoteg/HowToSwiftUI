//
//  View3DObject.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/27/23.
//

import SceneKit
import SwiftUI
//
//struct View3DObject: View {
//
//    @State var coordinator = UIView3DObject.Coordinator()
//
//    var body: some View {
//        UIView3DObject(coordinator: coordinator)
//        Button("Perspective 1", action: coordinator.changePerspective1)
//        Button("Perspective 2", action: coordinator.changePerspective2)
//        Button("Perspective 3", action: coordinator.changePerspective3)
//    }
//}
//
//struct UIView3DObject: UIViewRepresentable {
//
//    func makeCoordinator() -> Coordinator {
//        return coordinator
//    }
//
//    class Coordinator: NSObject {
//        let scene = SCNScene(named: "bitcoin_cash_logo.scn")!
//
//        lazy var cameraNode: SCNNode = {
//            let cameraNode = SCNNode()
//            cameraNode.camera = SCNCamera()
//            cameraNode.position = SCNVector3(x: 30, y: 30, z: 30)
//            return cameraNode
//        }()
//
//        lazy var lightNode: SCNNode = {
//            let lightNode = SCNNode()
//            lightNode.light = SCNLight()
//            lightNode.light?.type = .omni
//            lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//            return lightNode
//        }()
//
//        lazy var object3DNode: SCNNode = {
//            let object3DNode = scene.rootNode.childNode(withName: "root", recursively: true)!
//            object3DNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: .pi/4) // rotate around the x-axis by pi/4 radians
//
//            // Set pivot point at center of object3DNode
//            let boundingBox = object3DNode.boundingBox
//            let pivot = SCNMatrix4MakeTranslation(
//                (boundingBox.max.x - boundingBox.min.x) / 2 + boundingBox.min.x,
//                (boundingBox.max.y - boundingBox.min.y) / 2 + boundingBox.min.y,
//                (boundingBox.max.z - boundingBox.min.z) / 2 + boundingBox.min.z
//            )
//            object3DNode.pivot = pivot
//
//            return object3DNode
//        }()
//
//        func animateObject3D() {
//            let rotateAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(x: 0, y: 1, z: 0), duration: 20) // rotate around the y-axis
//            object3DNode.runAction(SCNAction.repeatForever(rotateAction))
//        }
//
//        // Add functions to change perspectives
//        func changePerspective1() {
//            let boundingBox = object3DNode.boundingBox
//            let center = SCNVector3(
//                x: (boundingBox.max.x - boundingBox.min.x) / 2 + boundingBox.min.x,
//                y: (boundingBox.max.y - boundingBox.min.y) / 2 + boundingBox.min.y,
//                z: (boundingBox.max.z - boundingBox.min.z) / 2 + boundingBox.min.z
//            )
//
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.0
//            cameraNode.position = center + SCNVector3(x: 0, y: boundingBox.max.y * 2, z: boundingBox.max.z * 2)
//            SCNTransaction.commit()
//        }
//
//        func changePerspective2() {
//            let boundingBox = object3DNode.boundingBox
//            let center = SCNVector3(
//                x: (boundingBox.max.x - boundingBox.min.x) / 2 + boundingBox.min.x,
//                y: (boundingBox.max.y - boundingBox.min.y) / 2 + boundingBox.min.y,
//                z: (boundingBox.max.z - boundingBox.min.z) / 2 + boundingBox.min.z
//            )
//
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.0
//            cameraNode.position = center + SCNVector3(x: 0, y: 0, z: boundingBox.max.z * 2)
//            SCNTransaction.commit()
//        }
//
//        func changePerspective3() {
//            let boundingBox = object3DNode.boundingBox
//            let center = SCNVector3(
//                x: (boundingBox.max.x - boundingBox.min.x) / 2 + boundingBox.min.x,
//                y: (boundingBox.max.y - boundingBox.min.y) / 2 + boundingBox.min.y,
//                z: (boundingBox.max.z - boundingBox.min.z) / 2 + boundingBox.min.z
//            )
//
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.0
//            cameraNode.position = center + SCNVector3(x: boundingBox.max.x * 2, y: 0, z: boundingBox.max.z * 2)
//            SCNTransaction.commit()
//        }
//
//    }
//
//    var coordinator: Coordinator = Coordinator()
//
//    func makeUIView(context: Context) -> SCNView {
//        let sceneView = SCNView(frame: .zero)
//        sceneView.scene = context.coordinator.scene
//        sceneView.allowsCameraControl = true
//        sceneView.autoenablesDefaultLighting = true
//        sceneView.scene?.rootNode.addChildNode(context.coordinator.cameraNode)
//        sceneView.scene?.rootNode.addChildNode(context.coordinator.lightNode)
//        sceneView.scene?.rootNode.addChildNode(context.coordinator.object3DNode)
//        context.coordinator.animateObject3D()
//
//        // Add look-at constraint to keep object3D centered to camera
//        let constraint = SCNLookAtConstraint(target: context.coordinator.object3DNode)
//        context.coordinator.cameraNode.constraints = [constraint]
//
//        // Calculate the bounding box of the object3D
//        let boundingBox = context.coordinator.object3DNode.boundingBox
//
//        // Calculate the center point of the bounding box
//        let center = SCNVector3(
//            x: (boundingBox.max.x - boundingBox.min.x) / 2.0 + boundingBox.min.x,
//            y: (boundingBox.max.y - boundingBox.min.y) / 2.0 + boundingBox.min.y,
//            z: (boundingBox.max.z - boundingBox.min.z) / 2.0 + boundingBox.min.z
//        )
//
//        // Set the camera node's position to be centered on the object3D
//        context.coordinator.cameraNode.position = center + SCNVector3(x: 0, y: 0, z: boundingBox.max.z * 2.5)
//
//        return sceneView
//    }
//
//    func updateUIView(_ view: SCNView, context: Context) {}
//}
//
struct View3DObject_Previews: PreviewProvider {
    static var previews: some View {
        View3DObject(fileName: "bitcoin_cash_logo.scn")
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

//import SceneKit
//import SwiftUI
//
//struct SceneKitView: UIViewRepresentable {
//    typealias UIViewType = SCNView
//
//    // MARK: - Properties
//    var scene: SCNScene
//    var cameraNode: SCNNode?
//    var lightNode: SCNNode?
//    var object3DNode: SCNNode?
//    var backgroundColor: UIColor = .systemBackground
//    var allowsCameraControl: Bool = true
//    var autoenablesDefaultLighting: Bool = true
//
//    // MARK: - Initializers
//    init(scene: SCNScene, cameraNode: SCNNode? = nil, lightNode: SCNNode? = nil, object3DNode: SCNNode? = nil) {
//        self.scene = scene
//        self.cameraNode = cameraNode
//        self.lightNode = lightNode
//        self.object3DNode = object3DNode
//    }
//
//    // MARK: - Helper Functions
//    func camera(position: SCNVector3) -> Self {
//        var copy = self
//        copy.cameraNode = SCNNode()
//        copy.cameraNode?.camera = SCNCamera()
//        copy.cameraNode?.position = position
//        return copy
//    }
//
//    func light(type: SCNLight.LightType, position: SCNVector3) -> Self {
//        var copy = self
//        copy.lightNode = SCNNode()
//        copy.lightNode?.light = SCNLight()
//        copy.lightNode?.light?.type = type
//        copy.lightNode?.position = position
//        return copy
//    }
//
//    func object(_ object: SCNNode) -> Self {
//        var copy = self
//        copy.object3DNode = object
//        return copy
//    }
//
//    func background(color: UIColor) -> Self {
//        var copy = self
//        copy.backgroundColor = color
//        return copy
//    }
//
//    func cameraControl(_ value: Bool) -> Self {
//        var copy = self
//        copy.allowsCameraControl = value
//        return copy
//    }
//
//    func defaultLighting(_ value: Bool) -> Self {
//        var copy = self
//        copy.autoenablesDefaultLighting = value
//        return copy
//    }
//
//    // MARK: - UIViewRepresentable
//    func makeUIView(context: Context) -> SCNView {
//        let sceneView = SCNView(frame: .zero)
//        sceneView.scene = scene
//
//        if let cameraNode = cameraNode {
//            sceneView.scene?.rootNode.addChildNode(cameraNode)
//        }
//
//        if let lightNode = lightNode {
//            sceneView.scene?.rootNode.addChildNode(lightNode)
//        }
//
//        if let object3DNode = object3DNode {
//            sceneView.scene?.rootNode.addChildNode(object3DNode)
//        }
//
//        sceneView.backgroundColor = backgroundColor
//        sceneView.allowsCameraControl = allowsCameraControl
//        sceneView.autoenablesDefaultLighting = autoenablesDefaultLighting
//
//        return sceneView
//    }
//
//    func updateUIView(_ uiView: SCNView, context: Context) {}
//}
//
//import SwiftUI
//import SceneKit
//
//struct ExampleView: View {
//
//    let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//    var body: some View {
//        SceneKitView(scene: scene)
//            .allowsCameraControl(true)
//            .backgroundColor(.white)
//            .autoenablesDefaultLighting(true)
//            .addCameraNode(createCameraNode())
//            .addLightNode(createLightNode())
//            .addObject3DNode(createObject3DNode())
//            .addConstraint(createLookAtConstraint(), to: createCameraNode())
//    }
//
//    func createCameraNode() -> SCNNode {
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
//        return cameraNode
//    }
//
//    func createLightNode() -> SCNNode {
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light?.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        return lightNode
//    }
//
//    func createObject3DNode() -> SCNNode {
//        let object3DNode = scene.rootNode.childNode(withName: "ship", recursively: true)!
//        return object3DNode
//    }
//
//    func createLookAtConstraint() -> SCNLookAtConstraint {
//        let constraint = SCNLookAtConstraint(target: createObject3DNode())
//        constraint.isGimbalLockEnabled = true
//        return constraint
//    }
//}

//import SceneKit
//import SwiftUI
//
//struct SceneKitView: UIViewRepresentable {
//    typealias UIViewType = SCNView
//    private let scene = SCNScene()
//    private var cameraNode: SCNNode?
//    private var lightNode: SCNNode?
//    private var objectNode: SCNNode?
//    private var sceneView: SCNView?
//
//    var allowsCameraControl: Bool = true
//    var autoenablesDefaultLighting: Bool = true
//    var backgroundColor: UIColor? = .black
//
//    init(_ block: (SCNScene) -> Void) {
//        block(scene)
//    }
//
//    func makeUIView(context: Context) -> SCNView {
//        let view = SCNView(frame: .zero)
//        view.scene = scene
//        view.allowsCameraControl = allowsCameraControl
//        view.autoenablesDefaultLighting = autoenablesDefaultLighting
//        view.backgroundColor = backgroundColor
//        cameraNode = SCNNode()
//        cameraNode?.camera = SCNCamera()
//        cameraNode?.position = SCNVector3(x: 0, y: 0, z: 5)
//        scene.rootNode.addChildNode(cameraNode!)
//        lightNode = SCNNode()
//        lightNode?.light = SCNLight()
//        lightNode?.light?.type = .omni
//        lightNode?.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode!)
//        if let objectNode = objectNode {
//            scene.rootNode.addChildNode(objectNode)
//        }
//        sceneView = view
//        return view
//    }
//
//    func updateUIView(_ view: SCNView, context: Context) {
//        if let objectNode = objectNode {
//            if !scene.rootNode.childNodes.contains(objectNode) {
//                scene.rootNode.addChildNode(objectNode)
//            }
//        }
//    }
//
//    func object(_ block: () -> SCNNode) -> Self {
//        var copy = self
//        copy.objectNode = block()
//        return copy
//    }
//
//    func camera(_ block: (SCNNode) -> Void) -> Self {
//        var copy = self
//        if let cameraNode = copy.cameraNode {
//            block(cameraNode)
//        }
//        return copy
//    }
//
//    func light(_ block: (SCNNode) -> Void) -> Self {
//        var copy = self
//        if let lightNode = copy.lightNode {
//            block(lightNode)
//        }
//        return copy
//    }
//}
//
//struct ExampleView: View {
//    var body: some View {
//        SceneKitView { scene in
//            // Set up the scene
//            scene.background.contents = UIColor.systemTeal
//        }
//        .object {
//            let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
//            let material = SCNMaterial()
//            material.diffuse.contents = UIColor.systemOrange
//            box.materials = [material]
//            return SCNNode(geometry: box)
//        }
//        .camera { camera in
//            camera.position = SCNVector3(x: 0, y: 0, z: 3)
//        }
//        .light { light in
//            light.position = SCNVector3(x: 0, y: 5, z: 5)
//        }
//    }
//}

import SwiftUI
import SceneKit

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

struct View3DObject: View {

    let fileName: String
    
    let rootNodeName: String
    
    let recusiveRootName: Bool
    
    @State private var rotateAnimationEnabled = false {
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
            
            Button(action: {
                self.rotateAnimationEnabled.toggle()
            }) {
                Text(rotateAnimationEnabled ? "Stop Rotation" : "Start Rotation")
            }
            
        } else {
            Text("Could Not Load Scene")
        }
    }
    
    public init(fileName: String, rootName: String = "root", recusiveRootName: Bool = true) {
        self.fileName = fileName
        self.rootNodeName = rootName
        self.recusiveRootName = recusiveRootName
        scene = SCNScene(named: fileName)
    }
    
    let actionName = "rotate"
    var isRotating: Bool = false
    let rotateAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(x: 0, y: 1, z: 0), duration: 20) // rotate around the y-axis
    
    func rotateAnimation() {
        if rotateAnimationEnabled {
            objectNode?.runAction(SCNAction.repeatForever(rotateAction), forKey: actionName)
        } else {
            objectNode?.removeAction(forKey: actionName)
        }
    }
}

