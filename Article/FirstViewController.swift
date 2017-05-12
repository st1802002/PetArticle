//
//  FirstViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/10.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase
class FirstViewController: UIViewController {
    
    let uid = memberIdCache.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        uid.currentUser = FIRAuth.auth()?.currentUser
        print("@@\(String(describing: uid.currentUser))")
        if ((uid.currentUser) != nil) {
            self.performSegue(withIdentifier: "toNavigationControllerSegue", sender: nil)
            print("HI")
        } else {
            self.performSegue(withIdentifier: "toLoginViewControllerSegue", sender: nil)
            print("Hello")
        }
    }
}
