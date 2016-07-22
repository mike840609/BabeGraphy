//
//  Network.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/22.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import PMAlertController

func fb_login(json:SwiftyJSON.JSON) -> SwiftyJSON.JSON{
    
    
    
    return json
}


// fb 登入
func fb_sugnup(json:SwiftyJSON.JSON){
    
    let name = json["last_name"].stringValue + json["first_name"].stringValue
    let email = json["email"].stringValue
    let fb_id = json["id"].stringValue
    let picture = json["picture"]["data"]["url"].stringValue
    let fb_token = FBSDKAccessToken.currentAccessToken().tokenString
    
    
    Alamofire.request(.POST, "http://140.136.155.143/api/auth/fb_signup",parameters: ["fb_id":fb_id ,"name":name ,"picture": picture , "email":email , "fb_token":fb_token]).responseJSON { (response) in
        
        switch response.result{
        case .Success(let json):
            
            print(json)
            
            let json = SwiftyJSON.JSON(json)
            
            let accessToken = json["token"].string
            
            print(accessToken)
            
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: ACCESS_TOKEN)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
            let alertVC = PMAlertController(title: "註冊成功", description: "恭喜您,讓我們共同創造美好的回憶", image: UIImage(named: "shield-1.png"), style: .Alert)
            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: {
                
                // 頁面轉跳
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            }))
            
            
            
        case .Failure(let error):
            print(error)
        }
        
    }
    
    
    
}