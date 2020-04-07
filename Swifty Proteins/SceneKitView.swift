//
//  SceneKitView.swift
//  Swifty Proteins
//
//  Created by Louise on 24/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    var view = SCNView()
    var scene: SCNScene
    @Binding var show: Bool
    @Binding var atomSelected: String
    var pointer: UnsafeMutablePointer<SCNNode>
    
    
    init(scene: SCNScene, show: Binding<Bool>, atomSelected: Binding<String>, pointer: UnsafeMutablePointer<SCNNode>) {
        self.scene = scene
        self._show = show
        self._atomSelected = atomSelected
        self.pointer = pointer
        view.scene = self.scene
        view.allowsCameraControl = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(named: "Background")
        view.antialiasingMode = .multisampling4X
    }
    
    class Coordinator: NSObject {
        
        var parent: SceneKitView
        @Binding var show: Bool
        @Binding var atomSelected: String
        
        init(_ sceneKitView: SceneKitView, show: Binding<Bool>, atomSelected: Binding<String>) {
            self.parent = sceneKitView
            self._show = show
            self._atomSelected = atomSelected
        }
        
        @objc func tapGesture(_ handleTap: UITapGestureRecognizer) {
            if handleTap.state == .ended {
                let view = handleTap.view as! SCNView
                let location = handleTap.location(in: view)
                let hits = view.hitTest(location, options: nil)
                if let tappedNode = hits.first?.node {
                    if self.show == false {
                        if let name = tappedNode.name {
                            self.atomSelected = name
                            withAnimation {
                                self.show.toggle()
                            }

                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, show: $show, atomSelected: $atomSelected)
    }
    
    func    makeUIView(context: Context) -> SCNView {
        let sceneView = self.view
        let gestureTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapGesture(_:)))
        sceneView.addGestureRecognizer(gestureTap)
        return sceneView
    }
    
    func    updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        pointer.initialize(to: scnView.defaultCameraController.pointOfView!)
    }
}
