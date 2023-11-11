
//
//  loginView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//


import SwiftUI

struct LoginView: View {
    
    @ObservedObject var db: DBConnection
    @ObservedObject var booksApi: BooksAPI
    
    
       @State var color = Color.black.opacity(0.7)
       @State var email = ""
       @State var password = ""
       @State var visible = false
       @State var isLoggedIn = false
       @State private var showAlert = false
       @State private var alertMessage = ""
      
    var body: some View {
                GeometryReader{ geometry in
                        NavigationLink(destination: RegisterView(db: db, booksApi: booksApi)
                            .navigationBarBackButtonHidden(true), label: {
                                Text("Register")
                                    .bold()
                                    .foregroundColor(.gray)
                            })
                        .padding()
                        
                        VStack {
                            
                            Image("login")
                                .resizable()
                                .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.4, alignment: .center)
                            Text("Log in to your account")
                                .font(.title3)
                                .bold()
                                .foregroundColor( Color.black.opacity(0.7))
                            
                            VStack(spacing: 15) {
                                TextField("Email", text: $email)
                                    .textInputAutocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.orange : self.color, lineWidth: 2))
                                
                                
                                HStack {
                                    VStack{
                                        
                                        if self.visible{
                                            TextField("Password", text: $password)
                                                .textInputAutocapitalization(.none)
                                        }else{
                                            SecureField("Password", text: $password)
                                                .textInputAutocapitalization(.none)
                                        }
                                    }
                                    
                                    Button(action: {
                                        self.visible.toggle()
                                    }){
                                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(self.color)
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.orange : self.color,lineWidth: 2))
                                
                            }
                            
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    if !email.isEmpty {
                                        
                                        db.resetPassword(email: email){ success in
                                            
                                            if !success {
                                                print("Failed to reset password!")
                                            }
                                        }
                                    }
                                }, label: {
                                    Text("Forget password")
                                        .bold()
                                        .foregroundColor(.gray)
                                })
                            }
                            
                            Button(action: {
                                            if email.isEmpty || password.isEmpty {
                                                showAlert = true
                                                alertMessage = "Please fill in both email and password fields."
                                            } else {
                                                db.LoginUser(email: email, password: password) { success in
                                                    if success {
                                                        isLoggedIn = true
                                                    } else {
                                                        showAlert = true
                                                        alertMessage = "Failed to log in. Please check your credentials."
                                                        print("Failed to logging in!")
                                                    }
                                                }
                                            }
                                        }, label: {
                                            Text("Log in")
                                                .foregroundColor(.white)
                                                .padding(.vertical)
                                                .frame(width: geometry.size.width * 0.9)
                                        })
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                        .padding(.top, 25)
                                        .alert(isPresented: $showAlert) {
                                            Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                        }
                            
                        }
                        .padding(.horizontal, 25)
                    }
                    
                }
            }



#Preview {
    LoginView(db: DBConnection(), booksApi: BooksAPI())
}
