//
//  DetailViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/10.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var missingTimeLabel: UILabel!
    @IBOutlet weak var missingLocationLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    let articleInfo = memberIdCache.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petNameLabel.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectRow]])?["petName"] as? String
        missingTimeLabel.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectRow]])?["missingTime"] as? String
        missingLocationLabel.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectRow]])?["missingLocation"] as? String
        let saveFilePathString = ((self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectRow]])?["missingPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
        petImage.image = UIImage(contentsOfFile: saveFilePath)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
