//
//  headerView.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/30.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class headerView: UICollectionReusableView {
    
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        /*
         
         // alignment
         let width = UIScreen.mainScreen().bounds.width
         
         // 320 / 16 = 20  (x, y) == 20  ,  320 / 4 = 80 (width,height) == 80
         avaImg.frame = CGRectMake(width/16, width/16, width/4, width/4)
         
         // x軸 分別開始位置 , y 軸都對齊 avaImg.frame.origin.y
         posts.frame = CGRectMake(width/2.5, avaImg.frame.origin.y, 50, 30)
         followers.frame = CGRectMake(width/1.7, avaImg.frame.origin.y, 50, 30)
         followings.frame = CGRectMake(width/1.25, avaImg.frame.origin.y, 50, 30)
         
         // titile 對齊標籤 , 下移 20
         postTitle.center = CGPointMake(posts.center.x, posts.center.y + 20)
         followersTitle.center = CGPointMake(followers.center.x, followers.center.y + 20)
         followings.center = CGPointMake(followings.center.x, followings.center.y + 20)
         
         
         editBtn.frame = CGRectMake(postTitle.frame.origin.x, postTitle.center.y + 20,
         width - postTitle.frame.origin.x - 10, 30)
         
         fullnameLbl.frame = CGRectMake(avaImg.frame.origin.x, avaImg.frame.origin.y + avaImg.frame.size.height,
         width - 30, 30)
         webTxt.frame = CGRectMake(avaImg.frame.origin.x - 5, fullnameLbl.frame.origin.y + 15,
         width - 30, 30)
         bioLbl.frame = CGRectMake(avaImg.frame.origin.x, webTxt.frame.origin.y + 30,
         width - 30, 30)
         
         */
        
        // round ava
        avaImg.contentMode = .ScaleAspectFill
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
    }
    
    @IBAction func followBtn_clicked(sender: AnyObject) {
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else{ return }
        
        guard let user = guestJSON.last else { return}
        
        guard let user_to_id = user["user_id"].string else { return}
        
        
        let title = editBtn.titleForState(.Normal)
        
        // 追蹤此人
        if title == "FOLLOW"{
            Alamofire.request(.POST, "http://140.136.155.143/api/connection/connect",parameters: ["token":AccessToken , "user_to_id":user_to_id]).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .Success( let json):
                    
                    self.editBtn.setTitle("FOLLOWING", forState: .Normal)
                    self.editBtn.backgroundColor = .greenColor()
                    
                    let json = SwiftyJSON.JSON(json)
                    
                    print(json)
                    
                    
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
                
            })
            
        }else{
            // 取消追蹤
            Alamofire.request(.POST, "http://140.136.155.143/api/connection/delete",parameters: ["token":AccessToken , "user_to_id":user_to_id]).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .Success( let json):
                    
                    let json = SwiftyJSON.JSON(json)
                    
                    self.editBtn.setTitle("FOLLOW", forState: .Normal)
                    self.editBtn.backgroundColor = UIColor(red: 0.81, green: 0.85, blue: 0.87, alpha: 1)
                    
                    
                    
                    print(json)
                    
                    
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
                
            })
            
            
        }
        
        
    }
}
