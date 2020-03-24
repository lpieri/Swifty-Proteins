//
//  SceneKitView.swift
//  Swifty Proteins
//
//  Created by Louise on 24/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI
import UIKit

struct SceneKitView: UIViewRepresentable {
    
    func    makeUIView(context: Context) -> UIView {
        return UIStoryboard(name: "DemoScene.scn", bundle: Bundle.main).instantiateInitialViewController()!.view
    }
    
    func    updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct SceneKitView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitView()
    }
}
