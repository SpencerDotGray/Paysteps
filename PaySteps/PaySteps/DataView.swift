//
//  DataView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/20/20.
//

import Foundation
import Firebase
import CryptoSwift

class DataView : ObservableObject {
    
    var db: Firestore? = nil
    @Published var currentUser: [String : Any]? = nil
    @Published var verified: Bool? = nil
    
    static let sharedInstance: DataView = {
        
        let instance = DataView()
        
        FirebaseApp.configure()
        
        instance.db = Firestore.firestore()
        
        return instance
    }()
    
    func getUser(email: String) {
        
        let userRef = db!.collection("users")
        
        userRef.whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {

                    //print("\(querySnapshot!.documents.first!.documentID) => \(querySnapshot!.documents.first!.data())")
                    
                    if let user = querySnapshot!.documents.first {
                        
                        DataView.sharedInstance.currentUser = user.data()
                    }
                }
            }
    }
    
    func verifyPassword(password: String) {
        
        DataView.sharedInstance.verified = nil
        
        let pass = "hbox\(password)salty".sha256()
        
        if let user = DataView.sharedInstance.currentUser {
            
            if user["password"] as! String == pass {
                
                DataView.sharedInstance.verified = true
            } else {
                DataView.sharedInstance.verified = false
            }
        }
    }
}
