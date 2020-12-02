//
//  LoginView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/20/20.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    func addUser() {
        
        vm.addUser(email: self.email, password: self.password, confirmPassword: self.confirmPassword)
    }
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                VStack {
                    if vm.passwordConfirmed == .doesNotMatch {
                        
                        Text("Passwords Do Not Match")
                            .foregroundColor(Color.red)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                    }
                    
                    if vm.passwordConfirmed == .empty {
                        
                        Text("Password field empty")
                            .foregroundColor(Color.red)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                    }
                    
                    if vm.emailFreeToUse == .invalid {
                        
                        Text("Invalid Email")
                            .foregroundColor(Color.red)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                    }
                    
                    if vm.emailFreeToUse == .alreadyInUse {
                        
                        Text("Account with email already exists")
                            .foregroundColor(Color.red)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                    }
                }
                
                VStack {
                    
                    HStack {
                        TextField("Email", text: self.$email)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: self.email) { _ in
                                vm.emailFreeToUse = .notDefined
                            }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple, lineWidth: 1)
                            .background(Color(red: 241/255, green: 243/255, blue: 248/255))
                            .frame(height: 50)
                    )
                    .frame(width: 325, height: 50)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    HStack {
                        SecureField("Password", text: self.$password)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: self.password) { _ in
                                vm.passwordConfirmed = .notDefined
                            }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple, lineWidth: 1)
                            .background(Color(red: 241/255, green: 243/255, blue: 248/255))
                            .frame(height: 50)
                    )
                    .frame(width: 325, height: 50)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    HStack {
                        SecureField("Confirm Password", text: self.$confirmPassword)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: self.confirmPassword) { _ in
                                vm.passwordConfirmed = .notDefined
                            }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple, lineWidth: 1)
                            .background(Color(red: 241/255, green: 243/255, blue: 248/255))
                            .frame(height: 50)
                    )
                    .frame(width: 325, height: 50)
                }
                
            }.background(Color(.white))
            
            Spacer()
                .frame(height: 25)
            
            Button(action: { addUser() }) {
                
                Text("Sign Up")
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
            }.background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple, lineWidth: 1)
                    .background(Color(red: 154/255, green: 179/255, blue: 245/255))
                    .frame(width: 325, height: 50)
            )
            .frame(width: 325, height: 45)
        }
    }
}

struct SignInView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    @State var email: String = ""
    @State var password: String = ""
    
    func login() {
        
        if vm.currentUser == nil {
            
            OperationQueue.main.addOperation {
                vm.getUser(email: self.email)
            }
        } else {
            
            OperationQueue.main.addOperation {
                vm.verifyPassword(password: self.password)
            }
        }
    }
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                if vm.verified == .invalid {
                    
                    Text("Password Not Correct")
                        .foregroundColor(Color.red)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 20.0)
                }
                
                if vm.loginEmail == .invalid {
                    
                    Text("Invalid Email")
                        .foregroundColor(Color.red)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 20.0)
                }
                
                HStack {
                    TextField("Email", text: self.$email)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal, 20.0)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onChange(of: self.email) {_ in
                            
                            vm.currentUser = nil
                            vm.loginEmail = .notDefined
                        }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple, lineWidth: 1)
                        .background(Color(red: 241/255, green: 243/255, blue: 248/255))
                        .frame(height: 50)
                )
                .frame(width: 325, height: 50)
                    
                if vm.currentUser != nil {
                    
                    Spacer()
                        .frame(height: 15)
                    
                    
                    HStack {
                        SecureField("Password", text: self.$password)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: self.password) { _ in
                                vm.verified = .notDefined
                            }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple, lineWidth: 1)
                            .background(Color(red: 241/255, green: 243/255, blue: 248/255))
                            .frame(height: 50)
                    )
                    .frame(width: 325, height: 50)
                    
                }
            }.background(Color(.white))
            
            Spacer()
                .frame(height: 25)
            
            Button(action: {login()}) {
                
                Text("\(vm.loginEmail != .valid ? "Next" : "Log In")")
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
            }.background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple, lineWidth: 1)
                    .background(Color(red: 154/255, green: 179/255, blue: 245/255))
                    .frame(width: 325, height: 50)
            )
            .frame(width: 325, height: 45)
        }
    }
}

struct LoginView: View {
    
    @State var signInView: Bool = true
    @ObservedObject var vm: DataView = DataView.sharedInstance
    
    var body: some View {
        
        VStack {
            
            Spacer()
                .frame(height: 75)
            
            HStack {
                
                Spacer()
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .foregroundColor(
                        self.signInView ? Color.blue : Color.gray
                    )
                    .onTapGesture {
                        self.signInView = true
                    }
                Spacer().frame(width: 15)
                Text(" | ")
                    .font(.largeTitle)
                    .fontWeight(.light)
                Spacer().frame(width: 15)
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .foregroundColor(
                        self.signInView ? Color.gray : Color.blue
                    )
                    .onTapGesture {
                        self.signInView = false
                    }
                Spacer()
            }
            
            Spacer()
            
            if self.signInView {
                SignInView()
                    .onAppear() {
                        vm.currentUser = nil
                        vm.verified = .notDefined
                        vm.loginEmail = .notDefined
                        vm.passwordConfirmed = .notDefined
                        vm.emailFreeToUse = .notDefined
                    }
                if vm.currentUser == nil {
                    Spacer()
                        .frame(height: 250)
                } else {
                    Spacer()
                        .frame(height: 185)
                }
            } else {
                SignUpView()
                    .onAppear() {
                        vm.currentUser = nil
                        vm.verified = .notDefined
                        vm.loginEmail = .notDefined
                        vm.passwordConfirmed = .notDefined
                        vm.emailFreeToUse = .notDefined
                    }
                Spacer()
                    .frame(height: 120)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
