//
//  memberIdCache.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/7.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase
class memberIdCache {
    var userId = ""
    var articleList: [String] = []
    var adoptionList: [String] = []
    var fireUploadDic: [String:Dictionary<String, Any>]?
    var adoptionFireUploadDic: [String:Dictionary<String, Any>]?
    var selectArticleRow = 0
    var selectAdoptionRow = 0
    var currentUser :FIRUser? = nil
    var myArticle: [String] = []
    var myAdoption: [String] = []
    

    private static var mInstance:memberIdCache?
    static func sharedInstance() -> memberIdCache {
        if mInstance == nil {
            mInstance = memberIdCache()
            
        }
        return mInstance!
    }
}
