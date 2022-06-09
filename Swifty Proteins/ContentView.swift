//
//  ContentView.swift
//  Swifty Proteins
//
//  Created by Louise on 18/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {

    @EnvironmentObject var proteins: Proteins
    @State private var showButtonFaceID = true
    @State private var showAlert = false
    @State private var textAlert = ""
    
    var body: some View {
        /* Code Array */
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            if proteins.isUnlocked {
                ResearchProteins()
            } else {
                VStack (alignment: .center, spacing: 42) {
                    Text("Swifty Proteins").font(.largeTitle).fontWeight(.semibold)
                    if showButtonFaceID {
                        Button(action: {
                            self.authenticate()
                        }) {
                            ZStack {
                                Circle().foregroundColor(Color("Button")).shadow(radius: 30)
                                Image(systemName: "faceid").font(.system(size: 42)).foregroundColor(Color("Shadow"))
                            }.frame(width: 100, height: 100)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Face ID Error"), message: Text(textAlert), dismissButton: .cancel())
                        }
                    } else {
                        Button(action: {
                            self.proteins.isUnlocked.toggle()
                        }) {
                            Text("Unlock without Face ID or Touch ID")
                        }
                    }
                }
            }
        }.onAppear(perform: checkFaceID)
        /* End Code Array */
    }
    
    /* Functions */
    
    func    checkFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                self.showButtonFaceID = true
            case .touchID:
                self.showButtonFaceID = true
            case .none:
                self.showButtonFaceID = false
            default:
                self.showButtonFaceID = false
            }
        }
    }
    
    func    authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authentificationError in
                DispatchQueue.main.async {
                    if success {
                        self.proteins.isUnlocked.toggle()
                    } else {
                        self.textAlert = "You have not been recognized by Face ID !"
                        self.showAlert = true
                    }
                }
            }
        } else {
            self.textAlert = "Face ID has not been activated !"
            self.showAlert = true
        }
    }
    /* End Functions */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Proteins(file: "ressources"))
            .environment(\.colorScheme, .light)
    }
}
