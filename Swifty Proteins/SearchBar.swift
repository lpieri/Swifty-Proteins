//
//  SearchBar.swift
//  Swifty Proteins
//
//  Created by Louise on 18/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI

struct SearchBar : UIViewRepresentable {
    
    @Binding var text : String
    
    class Cordinator : NSObject, UISearchBarDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> SearchBar.Cordinator {
        return Cordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor(named: "Background")
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
