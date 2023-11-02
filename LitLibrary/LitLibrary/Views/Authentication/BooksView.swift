//
//  BooksView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import SwiftUI

struct BooksView: View {
    
    @ObservedObject var db: DBConnection
    @ObservedObject var booksApi: BooksAPI
    
    
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            LogoView()
            SearchBar(searchText: $searchText)
            List{
                
            }
            
        }
        .padding()
        
        

    }
}

#Preview {
    BooksView(db: DBConnection(), booksApi: BooksAPI())
}
