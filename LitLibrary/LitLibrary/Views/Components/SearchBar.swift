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
            
            TextField("Search books", text: $searchText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button(action: {
                searchText = "" // Очистка текстового поля
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchBar(searchText: .constant("Search a book"))
                .frame(width: 300, height: 50)
        }
    }
}

