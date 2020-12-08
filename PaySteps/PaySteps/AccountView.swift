//
//  AccountView.swift
//  PaySteps
//
//  Created by Spencer Gray on 12/7/20.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var vm = DataView.sharedInstance
    @ObservedObject var pedometer = Pedometer.sharedInstance
    
    @State var inEdit: Bool = false
    @State var name: String = "temp"
    @State var email: String = "temp"
    @State var stepGoal: String = "temp"
    
    var body: some View {
        
        GeometryReader { metrics in
            ZStack {
                VStack {
                        
                    Spacer()
                        .frame(height: 80)
                    
                    VStack {
                        
                        Text("Step Progress")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .padding()
                        if vm.currentUser != nil {
                            ProgressView(value: Float(pedometer.getSteps() / (vm.currentUser!["stepGoal"] as! Int)))
                                .frame(width: metrics.size.width * 0.80)
                        } else {
                            ProgressView(value: 0.0)
                                .frame(width: metrics.size.width * 0.80)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.inEdit.toggle()
                            
                            if !inEdit && vm.currentUser != nil {
                                vm.changeValue(header: "name", value: self.name)
                                vm.changeValue(header: "email", value: self.email)
                                vm.changeValue(header: "stepGoal", value: Int(self.stepGoal))
                            }
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                                .frame(width: metrics.size.height * 0.05, height: metrics.size.height * 0.05)
                        }
                        Spacer().frame(width: metrics.size.width * 0.01)
                    }
                    VStack {
                        
                        Divider().background(Color.black)
                        HStack {
                            Spacer()
                                .frame(width: 25)
                            Text("Name: ")
                                .font(.title3)
                                .fontWeight(.light)
                            if inEdit {
                                TextField("name", text: self.$name)
                            } else {
                                Text("\(self.name)")
                            }
                            Spacer()
                        }.padding(.vertical, 5)
                        Divider().frame(width: metrics.size.width * 0.80)
                        HStack {
                            Spacer()
                                .frame(width: 25)
                            Text("Email: ")
                                .font(.title3)
                                .fontWeight(.light)
                            if inEdit {
                                TextField("email", text: self.$email)
                            } else {
                                Text("\(self.email)")
                            }
                            Spacer()
                        }.padding(.vertical, 5)
                        Divider().frame(width: metrics.size.width * 0.80)
                        HStack {
                            Spacer()
                                .frame(width: 25)
                            Text("Step Goal: ")
                                .font(.title3)
                                .fontWeight(.light)
                            if inEdit {
                                TextField("step goal", text: self.$stepGoal)
                            } else {
                                Text("\(self.stepGoal)")
                            }
                            Spacer()
                        }.padding(.vertical, 5)
                        Divider().background(Color.black)
                    }.background(Color.white)
                    
                    Spacer()
                    
                    VStack {
                        Divider().background(Color.black)
                        Button(action: {
                            if !self.inEdit {
                                vm.currentUser = nil
                                vm.verified = .notDefined
                                vm.loginEmail = .notDefined
                            }
                        }) {
                            
                            Text("Sign Out")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .frame(width: metrics.size.width, height: metrics.size.height * 0.05)
                        }
                        Divider().background(Color.black)
                    }.background(
                        self.inEdit
                            ? Color.gray
                            : Color(red: 154/255, green: 179/255, blue: 245/255)
                    )
                    .frame(width: metrics.size.width, height: metrics.size.height * 0.05)
                    
                    Spacer()
                        .frame(height: 40)
                        
                }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
            }
        }.onAppear {
            
            if vm.currentUser != nil {
                self.name = "\(vm.currentUser!["name"] ?? "")"
                self.email = "\(vm.currentUser!["email"] ?? "")"
                self.stepGoal = "\(vm.currentUser!["stepGoal"] ?? "")"
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
