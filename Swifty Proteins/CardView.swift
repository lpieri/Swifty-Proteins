//
//  CardView.swift
//  Swifty Proteins
//
//  Created by Louise on 31/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    @Binding var atomSelected: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(Color(UIColor.systemGray3))
            
            VStack {
                
                HStack {
                    Text("The atom selected is:")
                        .font(.title)
                        .fontWeight(.semibold)
                        
                    
                    Text(atomSelected)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                }.foregroundColor(.white)
                
                Spacer()
            }.padding()
        }
    }
}
//
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(atomSelected: <#T##Binding<String>#>)
//    }
//}
