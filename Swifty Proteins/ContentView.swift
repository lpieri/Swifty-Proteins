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
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        print(error)
                    }
                }
            }
        } else {
            print(error)
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack (spacing: 42) {
                
                Text("Swifty Proteins").font(.largeTitle).fontWeight(.semibold)
                
                Button(action: {
                    self.authenticate()
                }) {
                    ZStack {
                        Circle().foregroundColor(Color("Button")).shadow(color: Color("Shadow"), radius: 21)
                        Image(systemName: "faceid").font(.system(size: 60)).foregroundColor(Color("Shadow"))
                    }.frame(width: 121, height: 121)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .light)
    }
}
