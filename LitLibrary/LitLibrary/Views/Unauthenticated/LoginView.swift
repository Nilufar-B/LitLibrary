//
//  loginView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//


import SwiftUI

struct LoginView: View {
    
    @ObservedObject var db: DBConnection
    
       @State var color = Color.black.opacity(0.7)
       @State var email = ""
       @State var password = ""
       @State var visible = false
       @State var alert = false
       @State var error = ""
      
    var body: some View {
        ZStack{
            
            ZStack(alignment: .topTrailing){
                GeometryReader{ geometry in
                
                        VStack() {
                            
                            Image("login")
                                .resizable()
                                .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.4, alignment: .center)
                            Text("Log in to your account")
                                .font(.title3)
                                .bold()
                                .foregroundColor( Color.black.opacity(0.7))
                                .padding(.top, 35)
                            
                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.indigo : self.color, lineWidth: 2))
                                .padding(.top, 10)
                            
                            HStack(spacing: 15){
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
                            .padding(.top, 10)
                            
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
                            .padding(.top, 20)
                            
                            Button(action: {
                                
                                if !email.isEmpty && !password.isEmpty {
                                    
                                    let isSuccess = db.LoginUser(email: email, password: password)
                                       
                                       if !isSuccess {
                                           print("Failed to logging in!")
                                       }
                                    
                                }
                            }, label: {
                                Text("Log in")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            })
                            .background(Color.indigo)
//                            .disabled(!formIsValid)
//                            .opacity(formIsValid ? 1.0 : 0.5)
                            .cornerRadius(10)
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 25)
                    }
                NavigationLink(destination: RegisterView(db: DBConnection())
                    .navigationBarBackButtonHidden(true), label: {
                        Text("Register")
                            .bold()
                            .foregroundColor(.gray)
                    })
                    .padding()
                    
                }
            }
        }

}

#Preview {
    LoginView(db: DBConnection())
}

