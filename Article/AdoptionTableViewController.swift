//
//  AdoptionTableViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/10.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import Firebase

class AdoptionTableViewController: UITableViewController,UINavigationBarDelegate,UINavigationControllerDelegate {
    
    var menuView: BTNavigationDropdownMenu!
    let adoptionInfo = memberIdCache.sharedInstance()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petVariety: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        let items = ["民眾協尋資訊", "民眾領養資訊"]
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "民眾領養資訊", items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if (indexPath == 0) {
                self?.navigationController?.popViewController(animated: false)
            }
        }
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        loadFirebaseData()
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
                self?.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func checkImage(indexPathRow:Int) -> UIImage{
        let saveFilePathString = ((self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[indexPathRow]])?["AdoptionPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
        //        print("儲存位置是：\(saveFilePath)")
        let fileManager = FileManager()
        var isDir:ObjCBool = false
        let isExist = fileManager.fileExists(atPath: saveFilePath,isDirectory: &isDir)
        if isExist == true && isDir.boolValue == false{
            //            print("該檔案存在，是檔案")
            return UIImage(contentsOfFile: saveFilePath)!
        }else if isExist == false{
            //            print("該檔案不存在，下載檔案")
            downloadeImage(indexPathRow: indexPathRow,saveFilePath: saveFilePath)
        }
        return UIImage(named: "熊大.png")!
    }
    
    func downloadeImage(indexPathRow:Int,saveFilePath: String) {
        let saveFilePathStringURL = ((self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[indexPathRow]])?["AdoptionPetImageURL"] as? String)!
        let webAddress = saveFilePathStringURL
        let webURL = URL(string: webAddress)
        if let url = webURL{
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {
                (data:Data?, response:URLResponse?, error:Error?) in
                if error != nil{
                    //                        print("發生錯誤：\(error!.localizedDescription)")
                    return
                }
                if let downloadedData = data{
                    //                        print("暫存資料夾：\(saveFilePath)")
                    if let downloadeImage = UIImage(data:downloadedData){
                        if let dataToSave = UIImagePNGRepresentation(downloadeImage){
                            do{
                                try dataToSave.write(to: URL(fileURLWithPath: saveFilePath), options: [.atomic])
                                //                                    print("儲存成功")
                            }catch{
                                //                                    print("無法順利儲存")
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            task.resume()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adoptionInfo.adoptionList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! AdoptionTableViewCell
        let label1 = cell.contentView.viewWithTag(1) as! UILabel
        let label2 = cell.contentView.viewWithTag(2) as! UILabel
        let label3 = cell.contentView.viewWithTag(3) as! UILabel
        
        label1.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[indexPath.row]])?["petName"] as? String
        label2.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[indexPath.row]])?["petAge"] as? String
        label3.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[indexPath.row]])?["petVariety"] as? String
        
        cell.petImage.image = checkImage(indexPathRow: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adoptionInfo.selectAdoptionRow = indexPath.row
        performSegue(withIdentifier: "toAdoptionDetailViewControllerSegue", sender: nil)
    }
}
