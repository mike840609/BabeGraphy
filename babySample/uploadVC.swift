//
//  uploadVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/2.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Fusuma
import Alamofire
import SwiftyJSON
import PMAlertController


class uploadVC: UIViewController , UITextViewDelegate ,FusumaDelegate{
    
    
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    
    @IBOutlet weak var publishBtn: MaterialButton!
    @IBOutlet weak var removeBtn: MaterialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Upload"
        
        // disable publish btn
        publishBtn.enabled = false
        publishBtn.backgroundColor = .lightGrayColor()
        
        // hide remove button
        removeBtn.hidden = true
        
        // no image
        picImg.image = UIImage(named: "image.png")
        
        // hide kyeboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.showFusuma))
        picTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
        
        // first show  引導使用者 使用圖片
        showFusuma()
        
    }
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(image: UIImage) {
        
        // enable publish btn
        publishBtn.enabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // show removeBtn
        removeBtn.hidden = false
        
        print("Image selected")
        picImg.image = image
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        // enable publish btn
        publishBtn.enabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // show removeBtn
        removeBtn.hidden = false
        
        print("video completed and output to file: \(fileURL)")
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
        
        
        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alertVC = PMAlertController(title: "存取相簿", description: "請授與我們您的相簿存取權限,謝謝您", image: UIImage(named: "key.png"), style: .Alert)
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: {
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .Cancel, action: nil))
        self.presentViewController(alertVC, animated: true, completion: nil)
        
        
    }
    
    func fusumaClosed() {
        
        
        print("Called when the close button is pressed")
    }
    
    // MARK : - TextView
    
    
    // MARK: - Customer function
    // hide kyeboard function
    func showFusuma(){
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    // 新增po文
    func post(content:String){
        
        // 抓不到token ,token過期 ,重新登入一次
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // 轉跳登入畫面
            let alertVC = PMAlertController(title: "登入時效過期", description: "您的帳號已經從遠方登入,或者登入時效過期", image: UIImage(named: "warning.png"), style: .Alert)
            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{
                let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
                
            }))
            presentViewController(alertVC, animated: true, completion:nil)
        }
        
        guard let post_image = picImg.image else { return}
        
        
        Alamofire.request(.POST, "http://140.136.155.143/api/post/store",parameters: ["token":AccessToken!,"content":content]).responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
    
                print(json)
                
                guard let post_id = json["_id"].string else { return}
                
                
                
                // 照片上傳
                ApiService.shareInstance.postPhotoUpload(post_id, image: post_image)
                
                
                
                let alertVC = PMAlertController(title: "Po 文成功", description: "恭喜您,新增貼文成功", image: UIImage(named: "like_.png"), style: .Alert)
                
                // 轉跳 feed Controller
                alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{
                    let tabbar = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! tabVC
                    let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = tabbar
                    
                }))
                
                self.presentViewController(alertVC, animated: true, completion:nil)
                
                
            case .Failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    // MARK: - IBAction ================================================================================
    
    @IBAction func removeBtn_click(sender: AnyObject) {
        self.viewDidLoad()
    }
    
    @IBAction func publishBtn_click(sender: AnyObject) {
        
        print("post to server")
        
        post(titleTxt.text)
        
        self.view.endEditing(true)
        
    }
    
}
