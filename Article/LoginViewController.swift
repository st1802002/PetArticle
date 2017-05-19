//
//  LoginViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/4/19.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let articleInfo = memberIdCache.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        articleInfo.userId = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
//        let email : String! = "456@yahoo.com"
//        let password : String! = "123456"
        if email != "" && password != "" {
             FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil{
                    self.loginFail()
                }else{
                    if let user = FIRAuth.auth()?.currentUser{
                        self.articleInfo.userId = user.uid
                        self.dismiss(animated: false, completion: nil)
                    }
                }
             })
        }else{
            self.loginFail()
        }
    }
            
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
            
            
    @IBAction func SignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CreateAccountViewController = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController")as! CreateAccountViewController
        navigationController?.pushViewController(CreateAccountViewController, animated: true)
    }
    
    
    
    
    
    //登入功能
    func loginFeatures() {
        if self.emailTextField.text != "" || self.passwordTextField.text != "" {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion:
                { (user,error) in
                    if error == nil {
                        if let user = FIRAuth.auth()?.currentUser{
                            self.articleInfo.userId = user.uid
                            FIRDatabase.database().reference(withPath: "Online-Status/\(self.articleInfo)").setValue("ON")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let ArticleListTableViewController = storyboard.instantiateViewController(withIdentifier: "ArticleListTableViewController")as! ArticleListTableViewController
                            self.present(ArticleListTableViewController, animated: true, completion: nil)
                        }
                    }else{
                        self.loginFail()
                    }
            })
        }
    }
    
    
    //登入失敗訊息
    func loginFail() {
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        let alertController = UIAlertController(
            title: "登入失敗",
            message: "重新輸入帳號密碼",
            preferredStyle: .alert)
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
