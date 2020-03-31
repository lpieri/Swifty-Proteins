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
    @Binding var show: Bool
    @Binding var atomSelected: String
    
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
                        self.atomSelected = tappedNode.name!
                        withAnimation {
                            self.show.toggle()
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
