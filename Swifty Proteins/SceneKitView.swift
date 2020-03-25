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
    
    var scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
    }
    
    init(pathScene: String) {
        self.scene = SCNScene(named: pathScene)!
    }
    
    func    makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = scene
        return sceneView
    }
    
    func    updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor(named: "Background")
        scnView.showsStatistics = true
        scnView.debugOptions = .showWireframe
    }
    
    func    createBox() -> SCNNode {
        let boxGeometry = SCNBox(width: 20, height: 24, length: 40, chamferRadius: 0)
        let box = SCNNode(geometry: boxGeometry)
        box.name = "box"
        return box
    }
}

struct SceneKitView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitView(pathScene: "art.scnassets/ship.scn")
    }
}
