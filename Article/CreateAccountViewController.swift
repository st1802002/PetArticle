//
//  CreateAccountViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/4/19.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase


class CreateAccountViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if username != "" && email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil{
                    print("輸入資訊錯誤\(error!)")
                    self.signUpStatus(status: "fail")
                }else{
                    if let user = FIRAuth.auth()?.currentUser{
                        let uid = user.uid
                        FIRDatabase.database().reference(withPath: "ID/\(uid)/Profile/Username").setValue(self.usernameTextField.text)
                        FIRDatabase.database().reference(withPath: "ID/\(uid)/Profile/Email").setValue(self.emailTextField.text)
                        FIRDatabase.database().reference(withPath: "ID/\(uid)/Profile/Password").setValue(self.passwordTextField.text)
                        self.signUpStatus(status: "success")
                    }
                    // Store the uid for future access - handy!
                    UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                    
                }
            })
        } else {
            print("輸入資訊錯誤")
            self.signUpStatus(status: "fail")
        }
    }
    

    //註冊是否成功訊息
    func signUpStatus(status:String) {
        let okAction = UIAlertAction(title: "確認", style: .default) { (action: UIAlertAction!) -> Void in
            if status == "success"{
//                self.performSegue(withIdentifier: "segue", sender: nil)
              self.dismiss(animated: false, completion: nil)
            }
        }
        if status == "success"{
            let alertController = UIAlertController(
                title: "註冊成功",
                message: "請輸入帳號密碼登入",
                preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController,animated: false,completion: nil)
            
        }else{
            let alertController = UIAlertController(
                title: "註冊失敗",
                message: "請重新註冊",
                preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController,animated: false,completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
