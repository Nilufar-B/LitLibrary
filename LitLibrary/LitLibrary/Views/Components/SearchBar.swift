//
//  SearchBar.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-01.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search books...", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
        
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
                .opacity(searchText == "" ? 0 : 1)
            
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

    }
}

#Preview {
    SearchBar(searchText: .constant("Search a book..."))
}



