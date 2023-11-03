//
//  LitLibraryApp.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct LitLibraryApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var dbConnection = DBConnection()
    @StateObject var booksAPI = BooksAPI()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                //ContentView()
                LoginView(db: dbConnection, booksApi: booksAPI)
            }
        }
    }
}
