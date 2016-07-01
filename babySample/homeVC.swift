//
//  homeVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/30.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class homeVC: UICollectionViewController {
    
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // alaways vertical
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        collectionView?.backgroundColor = .whiteColor()
        
        // logoutBtn Set
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        logoutBtn.setTitleTextAttributes(attributes, forState: .Normal)
        logoutBtn.title = String.fontAwesomeIconWithName(.SignOut)
        
        
        
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    // header View
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        // 抓不到token ,token過期 ,重新登入一次
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // 轉跳登入畫面
            let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = signin
            
        }
        
        //        print(AccessToken)
        
            Alamofire.request(.GET, "http://140.136.155.143/api/user/token/\(AccessToken!)").validate().responseJSON{ (response) in
                
                switch response.result{
                case .Success(let json):
                    let json = SwiftyJSON.JSON(json)
                    
                    
                    // optional chainging
                    guard let id:String = json["data"][0]["id"].stringValue,
                        let name:String = json["data"][0]["name"].stringValue,
                        let email:String = json["data"][0]["email"].stringValue,
                        let follower:String = json["data"][0]["follower_count"].stringValue,
                        let following:String = json["data"][0]["followed_count"].stringValue
                        else {return}
                    
                    
                    
                    header.fullnameLbl.text = name.uppercaseString
                    header.posts.text  = "0"
                    header.followers.text = follower
                    header.followings.text = following
                    
                    print("id:\(id)\n name:\(name)\n email:\(email)\n follower:\(follower)\n following:\(following)\n==========================================")
                    
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                    
                }
        }
        
        
        return header
    }
    
    
    // Customer func - cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayOut:UICollectionViewLayout , sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
        
        let size = CGSize(width: self.view.frame.width/3, height:  self.view.frame.width/3)
        return size
        
    }
    
    // config cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - Customer Function
    func getInfo(){
        
        
        
        
    }
    
    // MARK: - IBAction
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
    }
    
    
    
}
