//
//  ProfileView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//


import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var db: DBConnection
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        if let user = db.currentUser {
            List{
                Section{
                    HStack {
                        Text("JD")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                        .clipShape(Circle())
                        VStack(alignment:.leading, spacing: 4){
                            Text("JD")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text("JD")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("General"){
                    HStack {
                        SettingsView(imageName: "gear",
                                     title: "Version",
                                     tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Account"){
                    Button(action: {
                        
                        print("Sign out...")
                        
                        let isSuccess = db.LoginUser(email: email, 
                                                     password: password)
                           
                           if !isSuccess {
                               print("Failed to log out!")
                           }
                        
                    }, label: {
                        SettingsView(imageName: "arrow.left.circle.fill",
                                     title: "Sign Out",
                                     tintColor: .red)
                    })
                    
                    Button(action: {
                        
                        print("Delete account...")
                        let isSuccess = db.deleteAccount()
                           
                           if !isSuccess {
                               print("Failed to delete account!")
                           }
                        
                    }, label: {
                        SettingsView(imageName: "xmark.circle.fill",
                                     title: "Delete account",
                                     tintColor: .red)
                    })
                }
            }
        }
        
    }
}

#Preview {
    ProfileView(db: DBConnection())
}

