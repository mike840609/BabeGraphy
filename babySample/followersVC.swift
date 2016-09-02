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
    
    
    // 用來儲存我使用者追蹤中的使用者 比對使用
    var myFollowingList : Array<SwiftyJSON.JSON> = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // 清空陣列緩存
        usernameArray.removeAll(keepCapacity: false)
        myFollowingList.removeAll(keepCapacity: false)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = show?.uppercaseString
        
        if show == "followers"{
            // 載入追蹤者名單 確定設值後在進行比對
            loadUserFollowingsList()
            
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
                    
                    // print(subJson)
                    
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
    
    // 追蹤中名單
    func loadUserFollowingsList(){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_following",parameters: ["token":AccessToken]).validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
                
                // 走訪陣列
                for (_,subJson):(String, SwiftyJSON.JSON) in json["data"] {
                    self.myFollowingList.append(subJson)
                }
                
                self.loadFollowers()
                
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
        
        
        cell.usernameLbl.text = follow[indexPath.item]["username"].string
        cell.followUserId = follow[indexPath.item]["user_id"].string
        
        // 圖片安全解包
        if let url = follow[indexPath.item]["profile_picture"].string {
            cell.avaImg.hnk_setImageFromURL(NSURL(string: url)!)
        }
        
        // 用id 判斷是否為本身
        if cell.followUserId == user!["data"][0][JSON_ID].string{
            cell.followBtn.hidden = true
        }
        // 每一筆都要判斷是否有追蹤
        if show == "followers"{
            
            // 追蹤按鈕判斷
            // 所有追蹤者 皆跟追蹤中的名單比對
            // 效率不好 會跑到 O(n^2) 效能需要改善
            for item in myFollowingList {
                
                if (item["user_id"].string == follow[indexPath.item]["user_id"].string){
                    
                    cell.followBtn.setTitle("FOLLOWING", forState: .Normal)
                    cell.followBtn.backgroundColor = .greenColor()
                }
            }
        }
        
        // 必定所有使用者都是追蹤中的 不需額外判斷
        if show == "followings"{
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
            
            // guestname.append(cell.usernameLbl.text!)
            
            print("\n\n",follow[indexPath.item])
            
            // 把要造訪的user 直接 append 到陣列中 供後面 guestVC用
            guestJSON.append(follow[indexPath.item])
            
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
            
        }
        
    }
    
    
    
    
}
