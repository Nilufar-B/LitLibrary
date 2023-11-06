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
            } else if let _ = authResult {
                print("Account created")
                
                let user = self.auth.currentUser
                            let changeRequest = user?.createProfileChangeRequest()
                            changeRequest?.displayName = name
                            changeRequest?.commitChanges { error in
                                if let error = error {
                                    print("Failed to set user name: \(error.localizedDescription)")
                                } else {
                                    print("User name set successfully")
                                }
                            }
                completion(true) // Registration successful
                
                self.db.collection("users").addDocument(data:["name": name, "email": email])
              
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
            // remove document of collection "users"
            db.collection("users").document(user.uid).delete { error in
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
        } else {
            print("No user is currently logged in.")
            completion(false)
        }
    }

        
        func resetPassword(email: String) -> Bool {
            var success = false
            
            auth.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Error sending password reset email: \(error.localizedDescription)")
                    success = false
                } else {
                    print("Password reset email sent successfully")
                    success = true
                }
            }
            
            return success
        }
    
//    func addFavoriteBook(bookTitle: String) {
//        if let user = currentUser {
//            let bookData = ["title": bookTitle]
//            dbReference.child("favoriteBooks").childByAutoId().setValue(bookData)
//        }
//    }


}

