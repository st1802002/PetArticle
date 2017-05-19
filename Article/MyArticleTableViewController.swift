//
//  MyArticleTableViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/15.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu

class MyArticleTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var menuView: BTNavigationDropdownMenu!
    let articleInfo = memberIdCache.sharedInstance()
    let firebaseURL = DataService()
    let firebaseDataReload = ArticleListTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        revealViewController().rearViewRevealWidth = 200
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        

        print("************\(articleInfo.myArticle.count)")
        loadMyArticle()
        print("************\(articleInfo.myArticle.count)")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let items = ["我的協尋文章", "我的領養文章"]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "我的協尋文章", items: items as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if (indexPath == 1) {
                self?.performSegue(withIdentifier: "toMyAdoptionTableViewController", sender: nil)
            }
        }
        print("viewWillAppear")
        self.tableView.reloadData()
    }
    
    func loadMyArticle(){
        articleInfo.myArticle = []
        for i in 0...articleInfo.articleList.count-1 {
            let uid = (String(describing: (articleInfo.fireUploadDic?[articleInfo.articleList[i]]?["UID"])!))
            if articleInfo.userId == uid{
                articleInfo.myArticle.append(articleInfo.articleList[i])
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
        return articleInfo.myArticle.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! MyArticleTableViewCell
        
        let label1 = cell.contentView.viewWithTag(1) as! UILabel
        let label2 = cell.contentView.viewWithTag(2) as! UILabel
        let label3 = cell.contentView.viewWithTag(3) as! UILabel
        
        label1.text = (self.articleInfo.fireUploadDic?[articleInfo.myArticle[indexPath.row]])?["petName"] as? String
        label2.text = (self.articleInfo.fireUploadDic?[articleInfo.myArticle[indexPath.row]])?["missingTime"] as? String
        label3.text = (self.articleInfo.fireUploadDic?[articleInfo.myArticle[indexPath.row]])?["missingLocation"] as? String
        
        cell.petImage.image = checkImage(indexPathRow: indexPath.row)
        return cell
    }
 
    func checkImage(indexPathRow:Int) -> UIImage{
        print("雞掰啦\(indexPathRow)")
        let saveFilePathString = ((self.articleInfo.fireUploadDic?[articleInfo.myArticle[indexPathRow]])?["missingPetImageFileName"] as? String)!
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let articleId = String(describing: articleInfo.myArticle[indexPath.row])
            
            self.firebaseURL.ARTICLEID_REF.child(articleId).removeValue(completionBlock: { (error, refer) in
                if error != nil {
                    print(error!)
                } else {
                    print(refer)
                    print("Child Removed Correctly")
                    self.articleInfo.myArticle.remove(at: indexPath.row)
                    self.loadFirebaseData()
                    print("!!!!!!!!!!!\(self.articleInfo.myArticle)")
                    tableView.reloadData()
                }
            })
        } else if editingStyle == .insert {

        }    
    }
 
    func loadFirebaseData () {
        DataService.dataService.ARTICLEID_REF.observe(.value, with: { [weak self] (snapshot) in
            if let uploadDataDic = snapshot.value as? [String:Dictionary<String, Any>] {
                self?.articleInfo.fireUploadDic = uploadDataDic
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    var tempArticleId: [String] = []
                    for snap in snapshots {
                        tempArticleId.insert(snap.key, at: 0) //文章ID
                        self?.articleInfo.articleList = tempArticleId
                    }
                }
                self?.tableView.reloadData()
            }
        })
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
