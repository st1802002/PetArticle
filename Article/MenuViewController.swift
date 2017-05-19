//
//  MenuViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/15.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    let uid = memberIdCache.sharedInstance()
    var iconImage:Array = [UIImage]()
    var menuLogin:Array = [String]()
    var menuNotLogin:Array = [String]()
    var rowNumber:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if ((FIRAuth.auth()?.currentUser) != nil){
            
            menuLogin = ["所有文章","我的文章","登出"]
            rowNumber = menuLogin.count
        }else{
            menuNotLogin = ["所有文章","登入"]
            rowNumber = menuNotLogin.count
        }
        iconImage = [UIImage(named:"熊大")!,UIImage(named:"熊大")!,UIImage(named:"熊大")!]
    }

    override func viewWillAppear(_ animated: Bool) {
        if ((FIRAuth.auth()?.currentUser) != nil){ //有上線
            menuLogin = ["所有文章","我的文章","登出"]
            rowNumber = menuLogin.count
            mainTableView.reloadData()
        }else{ // 離線
            menuNotLogin = ["所有文章","登入"]
            rowNumber = menuNotLogin.count
            mainTableView.reloadData()
        }
        iconImage = [UIImage(named:"熊大")!,UIImage(named:"熊大")!,UIImage(named:"熊大")!]
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        if ((FIRAuth.auth()?.currentUser) != nil) {
            cell.imageIcon.image = iconImage[indexPath.row]
            cell.menuLabel.text! = menuLogin[indexPath.row]
        }else{
            cell.imageIcon.image = iconImage[indexPath.row]
            cell.menuLabel.text! = menuNotLogin[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        print(cell.menuLabel.text!)
        
        if cell.menuLabel.text! == "所有文章"
        {
            print("所有文章 Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ArticleListTableViewController") as! ArticleListTableViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        if cell.menuLabel.text! == "我的文章"
        {
            print("我的文章 Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MyArticleTableViewController") as! MyArticleTableViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.menuLabel.text! == "登出"
        {
            print("登出 Tapped")
            if FIRAuth.auth()?.currentUser != nil {
                do {
                    print("登出了啦")
                    try FIRAuth.auth()?.signOut()
                    revealViewController().rightRevealToggle(animated: false)
                    uid.userId = ""
                    mainTableView.reloadData()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        if cell.menuLabel.text! == "登入"
        {
            print("登入 Tapped")
           self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        }

    }
}
