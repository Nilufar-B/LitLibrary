//
//  ContentView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import SwiftUI

struct ContentView: View {
    
  @StateObject var dbConnection = DBConnection()
    
    var body: some View {
        
        if let user = dbConnection.currentUser{
           NavigationStack{
               ProfileView(db: dbConnection)
            }
        } else {
            NavigationStack{
                LoginView(db: dbConnection)
            }
        }
    }
}

#Preview {
    ContentView()
}
