//
//  RegisterView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//


import Foundation
import SwiftUI

struct RegisterView:View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var visible = false
    @State var revisible = false
//    @State var alert = false
//    @State var error = ""
    
    var body: some View {
        ZStack{
            
            ZStack(alignment: .topTrailing){
                GeometryReader{ geometry in
                    VStack() {
                        
                        Image("login")
                            .resizable()
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.4, alignment: .center)
                        Text("Create an account")
                            .font(.title3)
                            .bold()
                            .foregroundColor( Color.black.opacity(0.7))
                            .padding()
                        
                        TextField("Name", text: self.$name)
                            .textInputAutocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.name != "" ? Color.indigo : self.color, lineWidth: 2))
                            .padding(.top, 10)
                        
                        TextField("Email", text: self.$email)
                            .textInputAutocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.indigo : self.color, lineWidth: 2))
                            .padding(.top, 10)
                        
                        HStack(spacing: 15){
                            VStack{
                                
                                if self.visible{
                                    TextField("Password", text: self.$password)
                                        .textInputAutocapitalization(.none)
                                }else{
                                    SecureField("Password", text: self.$password)
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
                        
                        ZStack(alignment: .trailing){
                            HStack(spacing: 15){
                                
                                VStack{
                                    if self.revisible{
                                        TextField("Confirm password", text: self.$confirmPassword)
                                            .textInputAutocapitalization(.none)
                                    }else{
                                        SecureField("Confirm password", text:  self.$confirmPassword)
                                            .textInputAutocapitalization(.none)
                                    }
                                }
                                Button(action: {
                                                             
                                 self.revisible.toggle()
                                                             
                                }) {
                                                             
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                              }
                            }
                            
                            if !password.isEmpty && !confirmPassword.isEmpty {
                                if password == confirmPassword {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGreen))
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemRed))
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.confirmPassword != "" ? Color.indigo : self.color,lineWidth: 2))
                        .padding(.top, 10)
              
                        Button(action: {
                         
                        }, label: {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        })
                        .background(Color.indigo)
//                        .disabled(!formIsValid)
//                        .opacity(formIsValid ? 1.0 : 0.5)
                        .cornerRadius(10)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                }
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), label: {
                    HStack{
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Text("Sign In")
                            .bold()
                            .foregroundColor(.gray)
                    }
                })
                .padding()
                
            }
        }
    }
    
}

//extension RegisterView: AuthenticationFormProtocol{
//    var formIsValid: Bool {
//        return !email.isEmpty
//        && email.contains("@")
//        && !password.isEmpty
//        && password.count > 5
//        && confirmPassword == password
//        && name.isEmpty
//    }
//}

#Preview {
    RegisterView()
}