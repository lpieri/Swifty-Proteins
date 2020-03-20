//
//  Proteins.swift
//  Swifty Proteins
//
//  Created by Louise on 18/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct  Protein: Identifiable {
    
    var id: NSNumber
    var name: String
    
    init () {
        self.id = NSNumber(0)
        self.name = "default"
    }
    
    init (id: NSNumber, name: String) {
        self.id = id
        self.name = name
    }
    
}

class   Proteins: ObservableObject {
    
    @Published var proteins: [Protein]
    @Published var isActive: Bool = false

    init(file: String) {
        self.proteins = [Protein]()
        if let fileUrl = Bundle.main.url(forResource: file, withExtension: ".txt") {
            if let fileContent = try? String(contentsOf: fileUrl) {
                let proteinsTable = fileContent.components(separatedBy: .newlines)
                var i: Int = 0
                for proteinsName in proteinsTable {
                    let newProtein = Protein(id: NSNumber(value: i), name: proteinsName)
                    self.proteins.append(newProtein)
                    i += 1
                }
            }
        }
    }
    
}
