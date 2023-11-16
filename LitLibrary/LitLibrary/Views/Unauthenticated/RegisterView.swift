//
//  RegisterView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//



import SwiftUI


struct RegisterView:View {
    
    @ObservedObject var db: DBConnection
    @ObservedObject var booksApi: BooksAPI
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var visible = false
    @State var revisible = false
    
    @State private var isRegistrationSuccess = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                VStack {
                    
                    Image("login")
                        .resizable()
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.4, alignment: .center)
                    
                    Text("Create an account")
                        .font(.title3)
                        .bold()
                        .foregroundColor( Color.black.opacity(0.7))
                        .padding(.top, 5)
                    
                    VStack(spacing: 15) {
                        TextField("Name", text:$name)
                            .textInputAutocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.name != "" ? Color.orange : self.color, lineWidth: 2))
                        
                        
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
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
                        
                        
                        ZStack(alignment: .trailing){
                            
                            
                            VStack{
                                if self.revisible{
                                    TextField("Confirm password", text: $confirmPassword)
                                        .textInputAutocapitalization(.none)
                                }else{
                                    SecureField("Confirm password", text:  $confirmPassword)
                                        .textInputAutocapitalization(.none)
                                }
                            }
                            Button(action: {
                                
                                self.revisible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
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
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.confirmPassword != "" ? Color.orange : self.color,lineWidth: 2))
                        Button(action: {
                            if !email.isEmpty && !password.isEmpty && password == confirmPassword {
                                db.userExists(email: email) { exists in
                                    DispatchQueue.main.async {
                                        if exists {
                                            showAlert = true
                                            alertMessage = "User with this email already exists."
                                        } else {
                                            db.RegisterUser(name: name, email: email, password: password, confirmPassword: confirmPassword) { success in
                                                if success {
                                                    isRegistrationSuccess = true
                                                } else {
                                                    print("Failed to create")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: geometry.size.width * 0.9)
                        })
                        .background(Color.orange)
                        .cornerRadius(10)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Registration Failed"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
                .padding(.horizontal, 25)
                NavigationLink(destination: LoginView(db: db, booksApi: booksApi).navigationBarBackButtonHidden(true), label: {
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
    RegisterView(db: DBConnection(), booksApi: BooksAPI())
}
