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
    
    enum SignUpEmail {
        
        case alreadyInUse
        case invalid
        case notDefined
        case valid
    }
    
    enum SignUpPassword {
        
        case doesNotMatch
        case notDefined
        case valid
        case empty
    }
    
    enum SignInPassword {
        
        case invalid
        case valid
        case notDefined
    }
    
    enum SignInEmail {
        
        case invalid
        case notDefined
        case valid
    }
    
    struct Notification {
        
        var title: String
        var description: String
    }
    
    struct Promotion {
        
        var title: String
        var description: String
        var cost: Int
        var image: UIImage?
    }
    
    var db: Firestore? = nil
    var storage: Storage? = nil
    @Published var currentUser: [String : Any]? = nil
    @Published var currentUserUID: String = ""
    @Published var loginEmail: SignInEmail = .notDefined
    @Published var verified: SignInPassword = .notDefined
    @Published var passwordConfirmed: SignUpPassword = .notDefined
    @Published var emailFreeToUse: SignUpEmail = .notDefined
    @Published var checkEmailCompletion: (() -> Void)? = nil
    @Published var activeNotifications: [Notification] = []
    @Published var activePromotions: [Promotion] = []
    
    static let sharedInstance: DataView = {
        
        let instance = DataView()
        
        FirebaseApp.configure()
        
        instance.db = Firestore.firestore()
        instance.storage = Storage.storage()
        
        return instance
    }()
    
    func addUser(email: String, password: String, confirmPassword: String) {
        
        if password == confirmPassword {
            DataView.sharedInstance.passwordConfirmed = .valid
        } else {
            DataView.sharedInstance.passwordConfirmed = .doesNotMatch
        }
        
        if password == "" {
            DataView.sharedInstance.passwordConfirmed = .empty
        }
        
        validateSignUpEmail(email: email, completion: {
            if DataView.sharedInstance.passwordConfirmed == .valid && DataView.sharedInstance.emailFreeToUse == .valid {
                
                if !email.contains("@") || !email.contains(".") {
                    DataView.sharedInstance.emailFreeToUse = .invalid
                }
                
                if DataView.sharedInstance.emailFreeToUse == .valid {
                    var ref: DocumentReference? = nil
                    ref = self.db!.collection("users").addDocument(data: [
                        "email": email,
                        "password": "hbox\(password)salty".sha256(),
                        "balance": 0,
                        "stepGoal": 0,
                        "name": ""
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            DataView.sharedInstance.getUser(documentID: ref!.documentID)
                        }
                    }
                }
            }
        })
        
    }
    
    func validateSignUpEmail(email: String, completion: @escaping () -> Void) {
        
        let userRef = db!.collection("users")
        
        DataView.sharedInstance.emailFreeToUse = .notDefined
        
        userRef.whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {

                    if querySnapshot!.documents.first != nil {
                        
                        DataView.sharedInstance.emailFreeToUse = .alreadyInUse
                    } else {
                        DataView.sharedInstance.emailFreeToUse = .valid
                    }
                }
            }
        
        let queue = OperationQueue()
        DataView.sharedInstance.checkEmailCompletion = completion
        queue.addOperation {
            while DataView.sharedInstance.emailFreeToUse == .notDefined {}
            DataView.sharedInstance.checkEmailCompletion!()
        }
    }
    
    func getUser(documentID: String) {
        
        let docRef = db!.collection("users").document(documentID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                DataView.sharedInstance.currentUser = document.data()
                DataView.sharedInstance.currentUserUID = document.documentID
                DataView.sharedInstance.loginEmail = .valid
                DataView.sharedInstance.verified = .valid
            } else {
                print("Document does not exist")
                DataView.sharedInstance.loginEmail = .invalid
                DataView.sharedInstance.currentUserUID = ""
            }
        }
    }
    
    func getUser(email: String) {
        
        let userRef = db!.collection("users")
        DataView.sharedInstance.loginEmail = .notDefined
        
        userRef.whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let user = querySnapshot!.documents.first {
                        
                        DataView.sharedInstance.currentUser = user.data()
                        DataView.sharedInstance.currentUserUID = user.documentID
                        DataView.sharedInstance.loginEmail = .valid
                    } else {
                        DataView.sharedInstance.loginEmail = .invalid
                        DataView.sharedInstance.currentUserUID = ""
                    }
                }
            }
    }
    
    func verifyPassword(password: String) {
        
        DataView.sharedInstance.verified = .notDefined
        
        let pass = "hbox\(password)salty".sha256()
        
        if let user = DataView.sharedInstance.currentUser {
            
            if user["password"] as! String == pass {
                
                DataView.sharedInstance.verified = .valid
            } else {
                DataView.sharedInstance.verified = .invalid
            }
        }
    }
    
    func loadNotifications() {
        
        let docRef = db!.collection("ads")
        
        docRef.whereField("live", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    DataView.sharedInstance.activeNotifications = []
                    
                    if let qs = querySnapshot {
                        
                        print("Number of Ads: \(qs.documents.count)")
                        
                        if qs.documents.count > 0 {
                            
                            for document in qs.documents {
                                
                                var temp = Notification(title: "", description: "")
                                
                                let title = document.data()["title"] as? String ?? ""
                                let description = document.data()["description"] as? String ?? ""
                                
                                if title != "" {
                                    temp.title = title
                                    temp.description = description
                                    DataView.sharedInstance.activeNotifications.append(temp)
                                }
                            }
                        }
                    }
                    
                    if DataView.sharedInstance.activeNotifications.count == 0 {
                        
                        DataView.sharedInstance.activeNotifications.append(Notification(title: "No Ads Available", description: "We currently have no available ads.\nSo here's a freebee on us.\n Don't worry, you're still getting cryptocurrency!"))
                    }
                }
            }
    }
    
    func loadPromotions() {
        
        let docRef = db!.collection("promotions")
        
        docRef.whereField("active", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    DataView.sharedInstance.activePromotions = []
                    
                    if let qs = querySnapshot {
                        
                        print("Number of Promotions: \(qs.documents.count)")
                        
                        if qs.documents.count > 0 {
                            
                            for document in qs.documents {
                                
                                var temp = Promotion(title: "", description: "", cost: 0)
                                
                                let title = document.data()["title"] as? String ?? ""
                                let description = document.data()["description"] as? String ?? ""
                                let cost = document.data()["cost"] as? Int ?? 0
                                let image = document.data()["image"] as? String ?? ""
                                
                                if title != "" {
                                    temp.title = title
                                    temp.description = description
                                    temp.cost = cost
                                    temp.image = nil
                                    DataView.sharedInstance.activePromotions.append(temp)
                                    DataView.sharedInstance.getPhoto(gsLink: image, index: DataView.sharedInstance.activePromotions.count-1)
                                }
                            }
                        }
                    }
                    
                    if DataView.sharedInstance.activeNotifications.count == 0 {
                        
                        DataView.sharedInstance.activeNotifications.append(Notification(title: "No Promotions Available", description: "No Promotions are Available.\nCome back another time"))
                    }
                }
            }
    }
    
    func getNotification() -> (title: String, description: String) {
        
        let randIndex: Int = Int.random(in: 0..<self.activeNotifications.count)
        
        let temp: (title: String, description: String) = (self.activeNotifications[randIndex].title, self.activeNotifications[randIndex].description)
        
        return temp
    }
    
    func changeBalance(amount: Int) {
        
        if currentUser != nil {
            
            let temp: Int = self.currentUser!["balance"] as! Int + amount
            
            db!.collection("users").document("\(self.currentUserUID)").setData([ "balance": temp ], merge: true)
            
            self.currentUser!["balance"] = temp
        }
        
    }
    
    func getPhoto(gsLink: String, index: Int) {
    
        if gsLink != "" {
            let gsReference = storage!.reference(forURL: "\(gsLink)")
            
            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("\(error)")
                    } else {
                        
                        let image = UIImage(data: data!)
                        DataView.sharedInstance.activePromotions[index].image = image
                    }
                }
        }

    }
    
    func changeValue<T>(header: String, value: T) {
        
        if currentUser != nil {
            
            db!.collection("users").document("\(self.currentUserUID)").setData([ "\(header)": value ], merge: true)
            
            self.currentUser!["\(header)"] = value
        }
    }
}
