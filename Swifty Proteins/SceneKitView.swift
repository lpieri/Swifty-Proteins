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
    
    class Coordinator: NSObject {
        
        var parent: SceneKitView
        
        init(_ sceneKitView: SceneKitView) {
            self.parent = sceneKitView
        }
        
        @objc func tapGesture(_ handleTap: UITapGestureRecognizer) {
            if handleTap.state == .ended {
                let view = handleTap.view as! SCNView
                let location = handleTap.location(in: view)
                let hits = view.hitTest(location, options: nil)
                if let tappedNode = hits.first?.node {
                    print(tappedNode.name)
                }
            }
        }
    }
    
    init(scene: SCNScene) {
        self.scene = scene
    }
    
    init(pathScene: String) {
        self.scene = SCNScene(named: pathScene)!
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func    makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let gestureTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapGesture(_:)))
        sceneView.scene = scene
        sceneView.addGestureRecognizer(gestureTap)
        return sceneView
    }
    
    func    updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.isUserInteractionEnabled = true
        scnView.backgroundColor = UIColor(named: "Background")
    }
}

struct SceneKitView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitView(pathScene: "art.scnassets/ship.scn")
    }
}
