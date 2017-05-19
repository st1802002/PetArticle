//
//  AdoptionDetailViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/17.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit

class AdoptionDetailViewController: UIViewController {
    
    let adoptionInfo = memberIdCache.sharedInstance()
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petGender: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petVariety: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var telephoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petName.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["petName"] as? String
        petGender.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["petGender"] as? String
        petAge.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["petAge"] as? String
        petVariety.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["petVariety"] as? String
        contactName.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["contactName"] as? String
        telephoneNumber.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["telephoneNumber"] as? String
        email.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["email"] as? String
        remark.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["remark"] as? String
 
        let saveFilePathString = ((self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["AdoptionPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
        petImage.image = UIImage(contentsOfFile: saveFilePath)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
