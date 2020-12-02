//
//  LoginView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/20/20.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
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
            
            ZStack {
                Color(red: 0.92, green: 0.92, blue: 0.92)
                VStack {
                    VStack {
                        
                        if vm.verified != nil && vm.verified == false {
                            
                            Divider()
                            Text("Password Not Correct")
                                .foregroundColor(Color.red)
                                .padding(.vertical, 5.0)
                                .padding(.horizontal, 20.0)
                                
                        }
                        
                        Divider()
                        TextField("Email", text: self.$email)
                            .padding(.vertical, 5.0)
                            .padding(.horizontal, 20.0)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: self.email) {_ in
                                
                                vm.currentUser = nil
                            }
                            
                        if vm.currentUser != nil {
                            
                            Divider()
                                .padding(.leading, 20.0)
                            
                            TextField("Password", text: self.$password)
                                .padding(.vertical, 5.0)
                                .padding(.horizontal, 20.0)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .onChange(of: self.password) { _ in
                                    vm.verified = nil
                                }
                        }
                        Divider()
                    }.background(Color(.white))
                    
                    Button(action: {login()}) {
                        
                        if vm.currentUser == nil {
                            Text("Next")
                        } else {
                            Text("Login")
                        }
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
