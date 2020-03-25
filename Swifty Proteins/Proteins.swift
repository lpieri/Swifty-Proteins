//
//  Proteins.swift
//  Swifty Proteins
//
//  Created by Louise on 18/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import Foundation
import Combine
import SceneKit
import SwiftUI

struct  Protein: Identifiable {
    
    var id: NSNumber
    var name: String
    var scene: SCNScene
    
    init () {
        self.id = NSNumber(0)
        self.name = "default"
        self.scene = SCNScene(named: "art.scnassets/ship.scn")!
    }
    
    init (id: NSNumber, name: String, scene: SCNScene) {
        self.id = id
        self.name = name
        self.scene = scene
    }
    
}

class   Proteins: ObservableObject {
    
    @Published var proteins: [Protein]
    @Published var isUnlocked: Bool = false

    init(file: String) {
        self.proteins = [Protein]()
        if let fileUrl = Bundle.main.url(forResource: file, withExtension: ".txt") {
            if let fileContent = try? String(contentsOf: fileUrl) {
                let proteinsTable = fileContent.components(separatedBy: .newlines)
                var i: Int = 0
                for proteinsName in proteinsTable {
                    let sceneProtein = createScene(name: proteinsName)
                    let newProtein = Protein(id: NSNumber(value: i), name: proteinsName, scene: sceneProtein)
                    self.proteins.append(newProtein)
                    i += 1
                }
            }
        }
    }
    
    func    createScene(name: String) -> SCNScene {
        let scene = SCNScene()
        let urlToGet = URL(string: "https://files.rcsb.org/ligands/view/\(name.uppercased())_model.sdf")!
        URLSession.shared.dataTask(with: urlToGet) { data, response, error in
            guard let data = data else { return }
            let file = String(data: data, encoding: .utf8)
            let lines = file?.components(separatedBy: .newlines)
            if lines![0] == name.uppercased() {
                for line in lines! {
                    if line.lengthOfBytes(using: .utf8) == 48 {
                        let informations = line.components(separatedBy: .whitespaces).filter({ $0 != "" })
                        let atom = self.createAtom(informations: informations)
                        scene.rootNode.addChildNode(atom)
                    }
                }
            }
        }.resume()
        return scene
    }
    
    func    createAtom(informations: [String]) -> SCNNode {
        let xDouble = Double(informations[0])!
        let yDouble = Double(informations[1])!
        let zDouble = Double(informations[2])!
        let atomSphere = SCNSphere(radius: 12)
        let atomNode = SCNNode(geometry: atomSphere)
        atomNode.position = SCNVector3(xDouble, yDouble, zDouble)
        atomNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        return atomNode
    }
    
}
