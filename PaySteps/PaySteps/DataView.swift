//
//  DataView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/20/20.
//

import Foundation
import Firebase

class DataView {
    
    struct Password: Hashable {
        
        var serialNumber: String
        var capacity: Int
    }
    
    var db: Firestore? = nil
    var dataVal: QueryDocumentSnapshot?
    
    static let sharedInstance: DataView = {
        
        let instance = DataView()
        
        FirebaseApp.configure()
        
        instance.db = Firestore.firestore()
        
        return instance
    }()
    
    // Return -2 if passwords do not match
    // Return -3 if database does not exist
    // Return 0 if worked
    func addUser(email: String, password: String, confirmPassword: String) -> Int {
        
        if password != confirmPassword {
            return -2
        }
        
        if let database = db {
            
            let hashedPass = Password(serialNumber: password, capacity: 512)
            var hasher = Hasher()
            hasher.combine(hashedPass)
            let hash = hasher.finalize()
            
            var _: DocumentReference? = database.collection("users").addDocument(data: [
                "email": email,
                "password": hash,
                "balance": 0
            ])
        } else {
            return -3
        }
        
        return 0
    }
    
    func getUser(uid: String) -> QueryDocumentSnapshot? {
        
        if let database = db {
            
            database.collection("users").getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        
                        if document.documentID == uid {
                            
                            self.dataVal = document
                        }
                    }
                }
            }
        }
        
        let val: QueryDocumentSnapshot? = self.dataVal
        self.dataVal = nil
        
        return val
    }
    
    func getUser(email: String) -> QueryDocumentSnapshot? {
        
        if let database = db {
            
            database.collection("users").getDocuments() { (querySnapshot, err) in

                if let err = err {
                    print("Error getting documents: \(err)")
                } else {

                    for document in querySnapshot!.documents {

                        if let em: String = document.data()["email"] as? String {

                            if em == email {
                                
                                OperationQueue.main.addOperation({
                                    DataView.sharedInstance.dataVal = document
                                })
                            }
                        }
                    }
                }
            }
        }
        
        let val: QueryDocumentSnapshot? = self.dataVal
        self.dataVal = nil
        
        return val
    }
}
