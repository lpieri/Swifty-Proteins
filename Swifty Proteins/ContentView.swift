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
    
    @State private var isUnlocked = false
    @State private var password: String = ""
    @EnvironmentObject var proteins: Proteins
    
    var body: some View {
        /* Code Array */
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            if isUnlocked {
                ResearchProteins()
            } else {
                VStack (alignment: .center, spacing: 42) {
                    Text("Swifty Proteins").font(.largeTitle).fontWeight(.semibold)
                    Button(action: {
                        self.authenticate()
                    }) {
                        ZStack {
                            Circle().foregroundColor(Color("Button")).shadow(radius: 30)
                            Image(systemName: "faceid").font(.system(size: 42)).foregroundColor(Color("Shadow"))
                        }.frame(width: 100, height: 100)
                    }
                }
            }
        }
        /* End Code Array */
    }
    
    /* Functions */
    func    authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authentificationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        print(authentificationError!)
                    }
                }
            }
        } else {
            print(error!)
        }
    }
    /* End Functions */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Proteins(file: "ressources")).environment(\.colorScheme, .light)
    }
}
