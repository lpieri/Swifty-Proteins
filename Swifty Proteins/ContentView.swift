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
//    let localAuthentificationContext = LAContext()
    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Please authenticate yourself to unlock your places."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//
//                DispatchQueue.main.async {
//                    if success {
//                        self.isUnlocked = true
//                        self.proteins.isActive = true
//                    } else {
//                        print(error)
//                    }
//                }
//            }
//        } else {
//            print(error)
//        }
//    }
    
    var body: some View {
        /* Code array */
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack (alignment: .center, spacing: 42) {
                    
                    Text("Swifty Proteins").font(.largeTitle).fontWeight(.semibold)
                    SecureField("Password", text: $password).font(.headline).padding()
                    
                    Button(action: {
                        self.proteins.isActive = true
                    }) {
                        ZStack {
                            Circle().foregroundColor(Color("Button")).shadow(radius: 5)
                            Image(systemName: "faceid").font(.system(size: 60)).foregroundColor(Color("Shadow"))
                        }.frame(width: 121, height: 121)
                    }

                    NavigationLink(destination: ResearchProteins(), isActive: $proteins.isActive) {
                        EmptyView()
                    }
                    
                }
            }
        }
        /* Code array */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Proteins(file: "ressources")).environment(\.colorScheme, .light)
    }
}
