//
//  followersCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/8.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire

class followersCell: UITableViewCell {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    var followUserId:String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // CORNER RTADIUS
        avaImg.contentMode = .ScaleAspectFill
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
    }
    
    
    @IBAction func followBtn_click(sender: AnyObject) {
        
        
        
        let title = followBtn.titleForState(.Normal)
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{
            return
        }
        
        // 標題而執行動作
        
        // 追蹤
        if title == "FOLLOW"{
    
            Alamofire.request(.POST, "http://140.136.155.143/api/connection/connect",parameters: ["token":AccessToken, "user_to_id": followUserId!]).validate().responseJSON(completionHandler: { (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    
                    print(json)
                    print(self.followUserId!)
                    
                    self.followBtn.backgroundColor = UIColor.greenColor()
                    self.followBtn.setTitle("FOLLOWING", forState: .Normal)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                    
                }
            })
            
            // 推播更新通知 homeVC
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)

            
        }
        
        // 取消追蹤
        if title == "FOLLOWING"{
            
            Alamofire.request(.POST, "http://140.136.155.143/api/connection/delete",parameters: ["token":AccessToken, "user_to_id": followUserId!]).validate().responseJSON(completionHandler: { (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    
                    print(self.followUserId!)
                    
                    print(json)
                    
                    self.followBtn.setTitle("FOLLOW", forState: .Normal)
                    self.followBtn.backgroundColor = .lightGrayColor()
                    
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
            })
            // 推播更新通知 homeVC
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)

        }
    }
    
}
