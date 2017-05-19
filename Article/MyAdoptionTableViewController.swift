//
//  MyAdoptionTableViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/17.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu

class MyAdoptionTableViewController: UITableViewController {


    @IBOutlet weak var menuButton: UIBarButtonItem!
    var menuView: BTNavigationDropdownMenu!
    let adoptionInfo = memberIdCache.sharedInstance()
    let firebaseURL = DataService()
    let firebaseDataReload = AdoptionTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        revealViewController().rearViewRevealWidth = 200
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let items = ["我的協尋文章", "我的領養文章"]
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "我的領養文章", items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if (indexPath == 0) {
                self?.navigationController?.popViewController(animated: false)
            }
        }
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))

        print("Hello:\(String(describing: (FIRAuth.auth()?.currentUser?.uid)!))")
        adoptionInfo.userId = (String(describing: (FIRAuth.auth()?.currentUser?.uid)!))
        
        print("*****************\(adoptionInfo.myAdoption.count)")
        if (adoptionInfo.adoptionList.count>0) {
            loadMyAdoption()
        }
        print("*****************\(adoptionInfo.myAdoption.count)")
    }
    
    func loadMyAdoption(){
        adoptionInfo.myAdoption = []
        for i in 0...adoptionInfo.adoptionList.count-1 {
            let uid = (String(describing: (adoptionInfo.adoptionFireUploadDic?[adoptionInfo.adoptionList[i]]?["UID"])!))
            if adoptionInfo.userId == uid{
                adoptionInfo.myAdoption.append(adoptionInfo.adoptionList[i])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adoptionInfo.myAdoption.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! MyAdoptionTableViewCell
        
        let label1 = cell.contentView.viewWithTag(1) as! UILabel
        let label2 = cell.contentView.viewWithTag(2) as! UILabel
        let label3 = cell.contentView.viewWithTag(3) as! UILabel
        
        label1.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.myAdoption[indexPath.row]])?["petName"] as? String
        label2.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.myAdoption[indexPath.row]])?["petAge"] as? String
        label3.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.myAdoption[indexPath.row]])?["petVariety"] as? String
        
        cell.petImage.image = checkImage(indexPathRow: indexPath.row)
        return cell
    }
    
    func checkImage(indexPathRow:Int) -> UIImage{
        print("輸贏啦\(indexPathRow)")
        let saveFilePathString = ((self.adoptionInfo.adoptionFireUploadDic?[adoptionInfo.myAdoption[indexPathRow]])?["AdoptionPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
                print("儲存位置是：\(saveFilePath)")
        let fileManager = FileManager()
        var isDir:ObjCBool = false
        let isExist = fileManager.fileExists(atPath: saveFilePath,isDirectory: &isDir)
        if isExist == true && isDir.boolValue == false{
            //            print("該檔案存在，是檔案")
            return UIImage(contentsOfFile: saveFilePath)!
        }else if isExist == false{
            //            print("該檔案不存在，下載檔案")
        }
        return UIImage(named: "熊大.png")!
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let adoption = String(describing: adoptionInfo.myAdoption[indexPath.row])
            
            self.firebaseURL.ADOPTION_REF.child(adoption).removeValue(completionBlock: { (error, refer) in
                if error != nil {
                    print(error!)
                } else {
                    print(refer)
                    print("Child Removed Correctly")
                    self.adoptionInfo.myAdoption.remove(at: indexPath.row)
                    self.loadFirebaseData()
                    print("!!!!!!!!!!!\(self.adoptionInfo.myAdoption)")
                    tableView.reloadData()
                }
            })
        } else if editingStyle == .insert {
            
        }
    }
    func loadFirebaseData () {
        DataService.dataService.ADOPTION_REF.observe(.value, with: { [weak self] (snapshot) in
            if let uploadDataDic = snapshot.value as? [String:Dictionary<String, Any>] {
                self?.adoptionInfo.adoptionFireUploadDic = uploadDataDic
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    var tempAdoption: [String] = []
                    for snap in snapshots {
                        tempAdoption.insert(snap.key, at: 0) //文章ID
                        self?.adoptionInfo.adoptionList = tempAdoption
                    }
                }
            }
        })
    }
}

