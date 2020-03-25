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

let CPKColor = [
    "H": UIColor(red: 0, green: 0, blue: 0, alpha: 1),
    "C": UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    "N": UIColor(red: 0, green: 0, blue: 1, alpha: 1),
    "O": UIColor(red: 1, green: 0, blue: 0, alpha: 1),
    "F": UIColor(red: 0, green: 1, blue: 0, alpha: 1),
    "CI": UIColor(red: 0, green: 1, blue: 0, alpha: 1),
    "Br": UIColor(red: 0.6, green: 0.13, blue: 0, alpha: 1),
    "I": UIColor(red: 0.4, green: 0, blue: 0.73, alpha: 1),
    "P": UIColor(red: 1, green: 0.564, blue: 0, alpha: 1),
    "S": UIColor(red: 1, green: 0.898, blue: 1.33, alpha: 1),
    "B": UIColor(red: 1, green: 0.66, blue: 0.46, alpha: 1),
    "Ti": UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
    "Fe": UIColor(red: 0.86, green: 0.46, blue: 0, alpha: 1),
]

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
        let atomSphere = SCNSphere(radius: 0.21)
        let atomNode = SCNNode(geometry: atomSphere)
        atomNode.position = SCNVector3(xDouble, yDouble, zDouble)
        atomNode.geometry?.firstMaterial?.diffuse.contents = CPKColor[informations[3]]
        return atomNode
    }
    
}
