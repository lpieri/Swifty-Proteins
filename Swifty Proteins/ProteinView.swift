//
//  ProteinVieew.swift
//  Swifty Proteins
//
//  Created by Louise on 24/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI
import SceneKit

struct ProteinView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showCardAtom = false
    @State var showAlert = false
    @State var showSpinningWheel = true
    @State var atomSelected: String = ""
    var protein: Protein
    
    var body: some View {
        /* Code Array */
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack {
                SceneKitView(scene: protein.scene, show: $showCardAtom, atomSelected: $atomSelected)
                    .edgesIgnoringSafeArea(.all)
            }.navigationBarTitle(Text(protein.name), displayMode: .inline)
            .navigationBarItems(leading: btnBack)
            .navigationBarItems(trailing: btnShare)
            
            CardView(atomSelected: $atomSelected)
                .gesture(
                    TapGesture()
                        .onEnded({
                            self.showCardAtom = false
                        })
                )
                .animation(.spring())
                .offset(y: showCardAtom ? UIScreen.main.bounds.height - 300 : UIScreen.main.bounds.height)
            
            if showSpinningWheel {
                SpinnigWheelView(isShowing: $showSpinningWheel)
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Protein Error"), message: Text("The sight of the ligand couldn't be loaded..."), dismissButton: .cancel({
                self.presentationMode.wrappedValue.dismiss()
            }))
        })
        .onAppear(perform: checkProteinScene)
        .onAppear(perform: spinningWheel)
        /* End Code Array */
    }
    
    /* Other View */
    var btnBack: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("Back")
            }
        }
    }
    
    var btnShare: some View {
        Button(action: {
//            let view = SCNView()
//            view.scene = self.protein.scene
//            view.backgroundColor = UIColor(named: "Background")
//            let image = view.snapshot()
//            print(image)
//            let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.blue)
        }
    }
    /* End Other View */
    
    /* Functions */
    func    spinningWheel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showSpinningWheel = false
        }
    }
    
    func    checkProteinScene() {
        let scene = self.protein.scene
        let node = scene.rootNode.childNode(withName: "atomNode", recursively: true)
        if node?.childNodes.count == 0 {
            self.showAlert = true
        }
    }
    /* End Functions */
}

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(protein: Protein())
    }
}
