//
//  ProteinVieew.swift
//  Swifty Proteins
//
//  Created by Louise on 24/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct ProteinView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var viewState = CGSize(width: 0, height: 600)
    @State var show = false
    @State var atomSelected: String = ""
    var protein: Protein
    
    var body: some View {
        /* Code Array */
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack {
                SceneKitView(scene: protein.scene, show: $show, atomSelected: $atomSelected)
                    .edgesIgnoringSafeArea(.all)
            }.navigationBarTitle(Text(protein.name), displayMode: .inline)
            .navigationBarItems(leading: btnBack)
            .navigationBarItems(trailing: btnShare)
            
            CardView(atomSelected: $atomSelected)
                .gesture(
                    TapGesture()
                        .onEnded({
                            self.show = false
                        })
                )
                .animation(.spring())
                .offset(y: show ? viewState.height : UIScreen.main.bounds.height)
        }
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
        Button(action: {}) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.blue)
        }
    }
    /* End Other View */
    
    /* Functions */
    /* End Functions */
}

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(protein: Protein())
    }
}
