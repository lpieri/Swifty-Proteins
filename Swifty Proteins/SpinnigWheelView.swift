//
//  SpinnigWheelView.swift
//  Swifty Proteins
//
//  Created by Louise on 06/04/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct SpinnigWheelView: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(Color(UIColor.systemGray5))
            
            VStack {
                Text("Loading")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            }
        }
        .shadow(radius: 30)
        .frame(width: 240, height: 240)
        .opacity(isShowing ? 1 : 0)
    }
}

struct SpinnigWheelView_Previews: PreviewProvider {
    static var previews: some View {
        SpinnigWheelView(isShowing: .constant(true))
    }
}
