//
//  DBConnection.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DBConnection: ObservableObject {
    
    var db = Firestore.firestore()

    var auth = Auth.auth()
    
   @Published var currentUser: User?
   @Published var name: String?
   @Published var favoriteBooks: [String] = []

    
    init() {
        
        auth.addStateDidChangeListener { auth, user in
            if let user = user {
                
                print("A user has logged in with email: \(user.email ?? "No email")")
                self.currentUser = user
  
            } else {
                
                self.currentUser = nil
                print("User has logged out")
            }
        }
    }

    func RegisterUser(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to create account: \(error.localizedDescription)")
                completion(false) // Registration failed
            } else if let authResult = authResult {
                print("Account created")
                
                let user = self.auth.currentUser
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("Failed to set user name: \(error.localizedDescription)")
                    } else {
                        print("User name set successfully")
                        
                        // Adding user data to the "users" collection with UID
                        let uid = authResult.user.uid
                        self.db.collection("users").document(uid).setData(["name": name, "email": email, "uid": uid])
                        
                        completion(true) // Registration successful
                    }
                }
            }
        }
    }

    
    func LoginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                completion(false) // Login not performed
            } else if let _ = authDataResult {
                print("Successfully logged in!")
                completion(true) // Login successful
                
            }
        }
    }

    
    func LogOutUser(completion: @escaping (Bool) -> Void) {
        var success = false

        do {
            try auth.signOut()
            self.currentUser = nil 
            success = true
            print("User signed out successfully")
        } catch let error as NSError {
            print("Error signing out: \(error.localizedDescription)")
            success = false
        }

        completion(success)
    }

    func deleteAccount(completion: @escaping (Bool) -> Void) {
        if let user = auth.currentUser {
            let uid = user.uid
            print("User UID: \(uid)")
            
            // Reference to the user's favorites document
            let userFavoritesRef = db.collection("users").document(uid).collection("favorites").document("favoritesDocument")
            
            userFavoritesRef.delete { error in
                if let error = error {
                    print("Error deleting user favorites document: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("User favorites document deleted successfully")
                    
                    // Now, remove the user document
                    self.db.collection("users").document(uid).delete { error in
                        if let error = error {
                            print("Error deleting user document: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            user.delete { error in
                                if let error = error {
                                    print("Error deleting account: \(error.localizedDescription)")
                                    completion(false)
                                } else {
                                    do {
                                        try self.auth.signOut()
                                        self.currentUser = nil
                                        print("Account deleted and user signed out successfully")
                                        completion(true)
                                    } catch let signOutError as NSError {
                                        print("Error signing out: \(signOutError.localizedDescription)")
                                        completion(false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            print("No user is currently logged in.")
            completion(false)
        }
    }

        
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Password reset email sent successfully")
                completion(true)
            }
        }
    }
    

    func userExists(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking user existence: \(error.localizedDescription)")
                completion(false)
            } else if let documents = snapshot?.documents, !documents.isEmpty {
                // User with the given email already exists
                print("User exists with email: \(email)")
                completion(true)
            } else {
                // User does not exist
                print("User does not exist with email: \(email)")
                completion(false)
            }
        }
    }

    
    
    func addFavoriteBook(bookId: String) {
        if let uid = currentUser?.uid {
            let userFavoritesRef = db.collection("users").document(uid).collection("favorites")
            
            // Check if the user already has a document
            userFavoritesRef.document("favoritesDocument").getDocument { (document, error) in
                if let document = document, document.exists {
                    // Document exists, update the array
                    userFavoritesRef.document("favoritesDocument").updateData([
                        "bookIds": FieldValue.arrayUnion([bookId])
                    ])
                } else {
                    // Document doesn't exist, create a new one with the array
                    userFavoritesRef.document("favoritesDocument").setData([
                        "bookIds": [bookId]
                    ])
                }
            }
        }
    }

    func getFavoriteBooks(completion: @escaping ([String]) -> Void) {
        if let uid = currentUser?.uid {
            let userFavoritesRef = db.collection("users").document(uid).collection("favorites").document("favoritesDocument")
            
            userFavoritesRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Document exists, retrieve the array
                    if let bookIds = document["bookIds"] as? [String] {
                        completion(bookIds)
                    } else {
                        completion([])
                    }
                } else {
                    // Document doesn't exist, user has no favorite books
                    completion([])
                }
            }
        } else {
            completion([])
        }
    }

    func fetchFavoriteBooks() {
        getFavoriteBooks { favoriteBooks in
            self.favoriteBooks = favoriteBooks
        }
    }
    
    func isBookInFavorites(bookId: String) -> Bool {
        return favoriteBooks.contains(bookId)
    }
    
    func updateFavoriteBooks() {
        if let uid = currentUser?.uid {
            let userFavoritesRef = db.collection("users").document(uid).collection("favorites").document("favoritesDocument")
            
            // Updating the array in favorites in the database
            userFavoritesRef.updateData([
                "bookIds": favoriteBooks
            ]) { error in
                if let error = error {
                    print("Error updating favorite books: \(error.localizedDescription)")
                } else {
                    print("Favorite books updated successfully")
                }
            }
        }
    }

    


}

