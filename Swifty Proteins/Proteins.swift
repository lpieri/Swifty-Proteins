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
    "H": UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    "C": UIColor(red: 0, green: 0, blue: 0, alpha: 1),
    "N": UIColor(red: 0, green: 0, blue: 1, alpha: 1),
    "O": UIColor(red: 1, green: 0, blue: 0, alpha: 1),
    "F": UIColor(red: 0, green: 1, blue: 0, alpha: 1),
    "CI": UIColor(red: 0, green: 1, blue: 0, alpha: 1),
    "BR": UIColor(red: 0.6, green: 0.13, blue: 0, alpha: 1),
    "I": UIColor(red: 0.4, green: 0, blue: 0.73, alpha: 1),
    "HE": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
    "NE": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
    "AR": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
    "XE": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
    "KR": UIColor(red: 0, green: 1, blue: 1, alpha: 1),
    "P": UIColor(red: 1, green: 0.564, blue: 0, alpha: 1),
    "S": UIColor(red: 1, green: 0.898, blue: 1.33, alpha: 1),
    "B": UIColor(red: 1, green: 0.66, blue: 0.46, alpha: 1),
    "LI": UIColor(red: 0.46, green: 0, blue: 1, alpha: 1),
    "NA": UIColor(red: 0.46, green: 0, blue: 1, alpha: 1),
    "K": UIColor(red: 0.46, green: 0, blue: 1, alpha: 1),
    "RB": UIColor(red: 0.46, green: 0, blue: 1, alpha: 1),
    "CS": UIColor(red: 0.46, green: 0, blue: 1, alpha: 1),
    "FR": UIColor(red: 0.46, green: 0, blue: 1, alpha: 1),
    "BE": UIColor(red: 0, green: 0.46, blue: 0, alpha: 1),
    "MG": UIColor(red: 0, green: 0.46, blue: 0, alpha: 1),
    "CA": UIColor(red: 0, green: 0.46, blue: 0, alpha: 1),
    "SR": UIColor(red: 0, green: 0.46, blue: 0, alpha: 1),
    "BA": UIColor(red: 0, green: 0.46, blue: 0, alpha: 1),
    "RA": UIColor(red: 0, green: 0.46, blue: 0, alpha: 1),
    "TI": UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
    "FE": UIColor(red: 0.86, green: 0.46, blue: 0, alpha: 1),
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
                let proteinsTable = fileContent.components(separatedBy: .newlines).filter({ $0 != "" })
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
        let atomChildNode = SCNNode()
        let linkChildNode = SCNNode()
        let urlToGet = URL(string: "https://files.rcsb.org/ligands/view/\(name.uppercased())_model.sdf")!
        var dictAtom = [Int: [String]]()
        var i = 1
        URLSession.shared.dataTask(with: urlToGet) { data, response, error in
            guard let data = data else { return }
            let file = String(data: data, encoding: .utf8)
            let lines = file?.components(separatedBy: .newlines)
            if lines![0] == name.uppercased() {
                for line in lines! {
                    if line.lengthOfBytes(using: .utf8) == 48 {
                        let informations = line.components(separatedBy: .whitespaces).filter({ $0 != "" })
                        dictAtom[i] = informations
                        let atom = self.createAtom(informations: informations)
                        atomChildNode.addChildNode(atom)
                        i += 1
                    }
                    if line.lengthOfBytes(using: .utf8) == 18 {
                        let dataLink = line.components(separatedBy: .whitespaces).filter({ $0 != "" })
                        var atomOne = Int(dataLink[0])!
                        var atomTwo = Int(dataLink[1])!
                        if dataLink[0].lengthOfBytes(using: .utf8) >= 4 {
                            self.splitAtom(str: dataLink[0], atomOne: &atomOne, atomTwo: &atomTwo)
                        }
                        let linkNode = self.createLink(atomOne: atomOne, atomTwo: atomTwo, dictAtom: dictAtom)
                        linkChildNode.addChildNode(linkNode)
                    }
                }
            }
        }.resume()
        scene.rootNode.addChildNode(atomChildNode)
        scene.rootNode.addChildNode(linkChildNode)
        return scene
    }
    
    func    splitAtom(str: String, atomOne: inout Int, atomTwo: inout Int) {
        var nbRight = 2
        var nbLeft = 2
        let size = str.lengthOfBytes(using: .utf8)
        if size == 5 {
            nbRight = 3
        } else if size == 6 {
            nbRight = 3
            nbLeft = 3
        }
        atomOne = Int(String(str.dropLast(nbRight)))!
        atomTwo = Int(String(str.dropFirst(nbLeft)))!
    }
    
    func    getCoord(informations: [String]) -> SCNVector3 {
        let xDouble = Double(informations[0])!
        let yDouble = Double(informations[1])!
        let zDouble = Double(informations[2])!
        return SCNVector3(xDouble, yDouble, zDouble)
    }
    
    func    createAtom(informations: [String]) -> SCNNode {
        let atomSphere = SCNSphere(radius: 0.21)
        let atomNode = SCNNode(geometry: atomSphere)
        atomNode.position = getCoord(informations: informations)
        atomNode.name = informations[3]
        atomNode.geometry?.firstMaterial?.diffuse.contents = CPKColor[informations[3].uppercased()] ?? UIColor(red: 0.86, green: 0.46, blue: 1, alpha: 1)
        return atomNode
    }
    
    func    createLink(atomOne: Int, atomTwo: Int, dictAtom: [Int: [String]]) -> SCNNode {
        let atomOneCoord = getCoord(informations: dictAtom[atomOne]!)
        let atomTwoCoord = getCoord(informations: dictAtom[atomTwo]!)
        let cylinderPos = SCNVector3(atomOneCoord.x - atomTwoCoord.x, atomOneCoord.y - atomTwoCoord.y, atomOneCoord.z - atomTwoCoord.z)
        let valToSqrt = (cylinderPos.x * cylinderPos.x) + (cylinderPos.y * cylinderPos.y) + (cylinderPos.z * cylinderPos.z)
        let length = sqrt(valToSqrt)
        let linkCylinder = SCNCylinder(radius: 0.05, height: CGFloat(length))
        let cylinderNode = SCNNode(geometry: linkCylinder)
        cylinderNode.position = SCNVector3((atomOneCoord.x + atomTwoCoord.x) / 2, (atomOneCoord.y + atomTwoCoord.y) / 2, (atomOneCoord.z + atomTwoCoord.z) / 2)
        cylinderNode.eulerAngles = SCNVector3Make(Float(Double.pi/2), acos((atomTwoCoord.z - atomOneCoord.z) / length), atan2((atomTwoCoord.y - atomOneCoord.y), (atomTwoCoord.x - atomOneCoord.x)))
        cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.systemGray
        return cylinderNode
    }
    
}
