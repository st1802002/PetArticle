//
//  Article.swift
//  Article
//
//  Created by 陳柏勳 on 2017/4/19.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import Foundation
import Firebase

class Article {
    private var _ArticleRef: FIRDatabaseReference
    private var _ArticleKey: String!
    private var _MissingLocation: String!
    private var _MissingTime: String!
    private var _PetName: String!
    
    var articleKey: String {
        return _ArticleKey
    }
    
    var missingLocation: String {
        return _MissingLocation
    }
    
    var missingTime: String {
        return _MissingTime
    }
    
    var petName: String {
        return _PetName
    }
    
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._ArticleKey = key
        
        if let missingLocation = dictionary["missingLocation"] as? String {
            self._MissingLocation = missingLocation
        }
        if let missingTime = dictionary["missingTime"] as? String {
            self._MissingTime = missingTime
        }
        if let petName = dictionary["petName"] as? String {
            self._PetName = petName
        }
        
        // The above properties are assigned to their key.
        
        self._ArticleRef = DataService.dataService.ARTICLEID_REF.child(self._ArticleKey)
        
    }}
