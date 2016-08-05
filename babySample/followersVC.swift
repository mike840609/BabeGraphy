//
//  followerVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PMAlertController
import Haneke

// 要顯示 storyBoardId
var show:String?


class followersVC: UITableViewController {
    
    
    var usernameArray = [String]()
    
    // 離線快取
    let cache = Shared.dataCache
    
    // 追蹤中 or 追蹤者 資料的json陣列
    // haneke 跟 swifty json 一定會衝突 要明確宣告類別 並直接實體化
    // var follow = [JSON]()
    var follow: Array<SwiftyJSON.JSON> = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        usernameArray.removeAll(keepCapacity: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = show?.uppercaseString
        
        if show == "followers"{
            loadFollowers()
        }
        
        if show == "followings"{
            loadFollowings()
        }
        
        
    }
    
    // MARK: - Customer function
    func loadFollowers(){
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_followers",parameters:["token":AccessToken]).validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                print(json)
                
                let json = SwiftyJSON.JSON(json)
                
                // 走訪陣列
                for (_,subJson):(String, SwiftyJSON.JSON) in json["data"] {
                    
                    print(subJson)
                    
                    
                    self.follow.append(subJson)
                    
                }
                
                self.tableView.reloadData()
                
            case .Failure(let error):
                print(error)
            }
        }
        
        
    }
    
    
    func loadFollowings(){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_following",parameters: ["token":AccessToken]).validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                print(json)
                
                let json = SwiftyJSON.JSON(json)
                
                // 走訪陣列
                for (_,subJson):(String, SwiftyJSON.JSON) in json["data"] {
                    
//                    print(subJson)
                    
                    self.follow.append(subJson)
                    
                }
                
                self.tableView.reloadData()
                
            case .Failure(let error):
                
                let alertVC = PMAlertController(title: "抱歉發生了某些問題", description: error.localizedDescription , image: UIImage(named: "error.png"), style: .Alert)
                alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                self.presentViewController(alertVC, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    // cell height
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        //  320 / 4 = 80
    //        return self.view.frame.size.width / 4
    //    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  follow.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        if show == "followers"{
            
            if cell.usernameLbl.text == user!["data"][0][JSON_NAME].string{
                cell.followBtn.hidden = true
            }
            
            cell.usernameLbl.text = follow[indexPath.item]["username"].string
            cell.followUserId = follow[indexPath.item]["user_id"].string
            cell.avaImg.hnk_setImageFromURL(NSURL(string: "http://www.sitesnobrasil.com/imagens-fotos/mulheres/l/lisa-simpson.png")!)
            cell.followBtn.setTitle("FOLLOWERS", forState: .Normal)
            
            // 圖片網址 未使用
            //print(follow[indexPath.item]["profile_picture"].string)
            
            cell.followBtn.backgroundColor = .greenColor()

        }
        
        
        if show == "followings"{
            
            if cell.usernameLbl.text == user!["data"][0][JSON_NAME].string{
                cell.followBtn.hidden = true
            }
            
            cell.usernameLbl.text = follow[indexPath.item]["username"].string
            cell.followUserId = follow[indexPath.item]["user_id"].string
            cell.avaImg.hnk_setImageFromURL(NSURL(string: "http://www.sitesnobrasil.com/imagens-fotos/mulheres/l/lisa-simpson.png")!)
            cell.followBtn.setTitle("FOLLOWING", forState: .Normal)
            
            cell.followBtn.backgroundColor = .greenColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
                // recall cell to call further cell's data
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
        
                // 判斷欄位是否是使用者本身
                if cell.followUserId == user!["data"]["0"][JSON_ID].string{
        
                    let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
                    self.navigationController?.pushViewController(home, animated: true)
        
                }else{
                    
                    guestname.append(cell.usernameLbl.text!)
                    
                    print("\n\n",follow[indexPath.item])
                    
                    // 把要造訪的user 直接 append 到陣列中 供後面 guestVC用
                    guestJSON.append(follow[indexPath.item])
                
                    let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
                    self.navigationController?.pushViewController(guest, animated: true)
                    
                }
        
        
    }
    
    
    
    
}
