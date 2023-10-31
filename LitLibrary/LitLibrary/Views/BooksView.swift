//
//  BooksView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import SwiftUI

struct BooksView: View {
    
    @ObservedObject var db: DBConnection
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  

    }
}

#Preview {
    BooksView(db: DBConnection())
}
