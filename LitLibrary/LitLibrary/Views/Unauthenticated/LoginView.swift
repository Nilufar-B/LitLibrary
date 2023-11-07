
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
      
    var body: some View {
        ZStack{
            
            ZStack(alignment: .topTrailing){
                NavigationStack{
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
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.indigo : self.color, lineWidth: 2))
                                
                                
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
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.indigo : self.color,lineWidth: 2))
                                
                            }
                            
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    if !email.isEmpty {
                                        
                                        let isSuccess = db.resetPassword(email: email)
                                        
                                        if !isSuccess {
                                            print("Failed to reset password!")
                                        }
                                    }
                                }, label: {
                                    Text("Forget password")
                                        .bold()
                                        .foregroundColor(.gray)
                                })
                            }
                          
                            Spacer()
                            
                            Button(action: {
                                
                                if !email.isEmpty && !password.isEmpty {

                                    db.LoginUser(email: email, password: password){ success in
                                        
                                        if success{
                                            isLoggedIn = true
                                        }else {
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
                            .navigationDestination(isPresented: $isLoggedIn, destination: {
                                BooksView(db: db, booksApi: booksApi)
                            })
                            .background(Color.indigo)
                            //                            .disabled(!formIsValid)
                            //                            .opacity(formIsValid ? 1.0 : 0.5)
                            .cornerRadius(10)
                           
                        }
                        .padding(.horizontal, 25)
                    }
                
                }
            }
        }
    }
}

#Preview {
    LoginView(db: DBConnection(), booksApi: BooksAPI())
}
