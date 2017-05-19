//
//  DataService.swift
//  Article
//
//  Created by 陳柏勳 on 2017/4/19.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase

class DataService: NSObject{
    static let dataService = DataService()
    
    private var _BASE_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
    private var _USER_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/UID")
    private var _ARTICLEID_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/ArticleID")
    private var _ADOPTION_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    var ARTICLEID_REF: FIRDatabaseReference {
        return _ARTICLEID_REF
    }
    var ADOPTION_REF: FIRDatabaseReference {
        return _ADOPTION_REF
    }
    
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        let currentUser = FIRDatabase.database().reference(fromURL: "\(BASE_REF)").child("users").child(userID)
        return currentUser
    }
    
    func createNewAccount(_ uid: String, user: Dictionary<String, String>) {
        USER_REF.child(uid).setValue(user)
    }
    
    func createNewArticle (_ article: Dictionary<String, AnyObject>) {
        let firebaseNewArticle = ARTICLEID_REF.childByAutoId()
        firebaseNewArticle.setValue(article)
    }
    func createNewAdoption (_ adoption: Dictionary<String, AnyObject>) {
        let firebaseNewAdoption = ADOPTION_REF.childByAutoId()
        firebaseNewAdoption.setValue(adoption)
    }

}
