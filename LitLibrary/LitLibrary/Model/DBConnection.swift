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
    
    func RegisterUser(name: String, email: String, password: String, confirmPassword: String) -> Bool {
        
        var success = false
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                
                print(error.localizedDescription)
                success = false
                return
            }
            if let _ = authResult {
                print("Account created")
                success = true
            }
        }
        
        return success
    }
    
    func LoginUser(email: String, password: String) -> Bool {
        
        var success = false
        
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            
            if let _ = error {
                print("Error logging in")
                success = false
            }
            
            if let _ = authDataResult {
                print("Successfully logged in!")
                success = true
            }
        }
        
        return success
    }
    
    func logOutUser() -> Bool {
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

        return success
    }
    
    func deleteAccount() -> Bool {
            var success = false
            
            if let user = auth.currentUser {
                user.delete { error in
                    if let error = error {
                        print("Error deleting account: \(error.localizedDescription)")
                        success = false
                    } else {
                        self.currentUser = nil
                        print("Account deleted successfully")
                        success = true
                    }
                }
            } else {
                print("No user is currently logged in.")
                success = false
            }
            
            return success
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


}

