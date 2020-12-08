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
        
        GeometryReader { metrics in
            
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
                        
                        HStack { // Sign Up Email Field
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
                                .background(RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white))
                                .frame(height: 50)
                        )
                        .frame(width: metrics.size.width * 0.85, height: 50)
                        
                        Spacer()
                            .frame(height: 15)
                        
                        HStack { // Sign Up Password Field
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
                                .background(RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white))
                                .frame(height: 50)
                        )
                        .frame(width: metrics.size.width * 0.85, height: 50)
                        
                        Spacer()
                            .frame(height: 15)
                        
                        HStack { // Sign Up Confirm Password Field
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
                                .background(RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white))
                                .frame(height: 50)
                        )
                        .frame(width: metrics.size.width * 0.85, height: 50)
                    }
                    
                }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
                
                Spacer()
                    .frame(height: 25)
                
                Button(action: { addUser() }) {
                    
                    Text("Sign Up")
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                        .frame(width: metrics.size.width * 0.85)
                }.background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 154/255, green: 179/255, blue: 245/255)))
                        .frame(width: metrics.size.width * 0.85, height: 50)
                )
                .frame(width: metrics.size.width, height: 45)
            }
        }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
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
        
        GeometryReader { metrics in
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
                            .background(RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white))
                            .frame(height: 50)
                    )
                    .frame(width: metrics.size.width * 0.85, height: 50)
                        
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
                                .background(RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white))
                                .frame(height: 50)
                        )
                        .frame(width: metrics.size.width * 0.85, height: 50)
                        
                    }
                }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
                
                Spacer()
                    .frame(height: 25)
                
                Button(action: {login()}) {
                    
                    Text("\(vm.loginEmail != .valid ? "Next" : "Log In")")
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                        .frame(width: metrics.size.width * 0.85)
                }.background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 154/255, green: 179/255, blue: 245/255)))
                        .frame(width: metrics.size.width * 0.85, height: 50)
                )
                .frame(width: metrics.size.width, height: 45)
            }
        }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
    }
}

func checkForLogin() -> Bool {
    
    if let filepath = Bundle.main.path(forResource: "LocalData", ofType: "txt") {
        do {
            let contents = try String(contentsOfFile: filepath)
            
            if contents.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                
                DataView.sharedInstance.getUser(email: contents.trimmingCharacters(in: .whitespacesAndNewlines))
                DataView.sharedInstance.loginEmail = .valid
                DataView.sharedInstance.verified = .valid
                
                return true
                
            } else {
                return false
            }
        } catch {
            // contents could not be loaded
            return false
        }
    } else {
        // example.txt not found!
        return false
    }
}

struct LoginView: View {
    
    @State var signInView: Bool = true
    @ObservedObject var vm: DataView = DataView.sharedInstance
    
    var body: some View {
        
        GeometryReader { metrics in
            VStack {
                
                Spacer()
                    .frame(height: metrics.size.height * 0.15)
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
                    .frame(height: metrics.size.height * 0.10)
                
                if self.signInView {
                    SignInView()
                        .onAppear() {
                            vm.currentUser = nil
                            vm.verified = .notDefined
                            vm.loginEmail = .notDefined
                            vm.passwordConfirmed = .notDefined
                            vm.emailFreeToUse = .notDefined
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
                }
            }.frame(width: metrics.size.width, height: metrics.size.height)
            .background(Color(red: 241/255, green: 243/255, blue: 248/255))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
