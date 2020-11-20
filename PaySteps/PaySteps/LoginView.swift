//
//  LoginView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/20/20.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let vm: DataView = DataView.sharedInstance
    @State var details: String = ""
    
    func user() {
        
        var data: QueryDocumentSnapshot?
        
        OperationQueue.main.addOperation {
            data = vm.getUser(email: "email@email.com")
        }
        
        //OperationQueue.main.waitUntilAllOperationsAreFinished()
        
        if let d = data {
            
            self.details = d.data()["email"] as! String
        } else {
            
            self.details = "Did not work"
        }
    }
    
    var body: some View {
        
        VStack {
            Text("\(self.details)")
            Button(action: {user()}) {
                Text("Get User with email: email@email.com")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
