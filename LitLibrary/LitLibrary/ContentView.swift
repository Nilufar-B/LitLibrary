//
//  ContentView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import SwiftUI

struct ContentView: View {
    
  @StateObject var dbConnection = DBConnection()
  @StateObject var booksAPI = BooksAPI()
  @State private var isUserLoggedIn = false
    
//    @ObservedObject var dbConnection: DBConnection
//    @ObservedObject var booksAPI: BooksAPI
    
    var body: some View {
        NavigationStack{
                if let _ = dbConnection.currentUser{
           TabView {
                    BooksView(db: dbConnection, booksApi: booksAPI)
                        .tabItem {
                            Image(systemName: "house")
                                .renderingMode(.template)
                        }
                    FavoritesView()
                        .tabItem {
                            Image(systemName: "heart")
                                .renderingMode(.template)
                        }
                    ProfileView(db: dbConnection, booksApi: booksAPI)
                        .tabItem {
                            Image(systemName: "person")
                                .renderingMode(.template)
                        }
                    }
           .accentColor(.orange)
                } else {
                        LoginView(db: dbConnection, booksApi: booksAPI)
                    }
                }
        
   
    }
    
}

#Preview {
    ContentView(dbConnection: DBConnection(), booksAPI: BooksAPI())
}
