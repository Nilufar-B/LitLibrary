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
        
        Button(action: {
            if db.logOutUser() {
                // Handle successful sign-out, e.g., navigate to the login screen
                NavigationLink(destination: LoginView(db: DBConnection())
                    .navigationBarBackButtonHidden(true), label: {
                        Text("Sign out")
                            .bold()
                            .foregroundColor(.gray)
                    })
            } else {
                // Handle sign-out error
            }
        }) {
            Text("Sign Out")
        }

    }
}

#Preview {
    BooksView(db: DBConnection())
}
