//
//  ResearchProteins.swift
//  Swifty Proteins
//
//  Created by Louise on 18/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct ResearchProteins: View {
    
    @EnvironmentObject var proteins: Proteins
    @State private var searchValue: String = ""
    
    var body: some View {
        /* Code Array */
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                /* Body */
                VStack (alignment: .leading) {
                    TextField("Research Proteins", text: $searchValue)
                        .font(.headline)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray))
                        .shadow(radius: 30)
                    
                    List {
                        ForEach (proteins.proteins.filter {
                            searchValue.isEmpty ? true : $0.name.contains(searchValue)
                        }, id: \.id) { protein in
                            NavigationLink(destination: ProteinView(protein: protein)) {
                                Text(protein.name)
                            }
                        }.listRowBackground(Color("Background"))
                    }.onAppear() {
                        UITableView.appearance().backgroundColor = UIColor(named: "Background")
                        UITableView.appearance().separatorColor = UIColor(named: "Shadow")
                        UITableView.appearance().separatorStyle = .singleLine
                    }.id(UUID())
                }.padding()
                .navigationBarTitle("Proteins", displayMode: .large)
                /* Body */
            }
        }
        /* Code Array */
    }
}

struct ResearchProteins_Previews: PreviewProvider {
    static var previews: some View {
        ResearchProteins()
            .environmentObject(Proteins(file: "ressources"))
            .environment(\.colorScheme, .light)
    }
}
