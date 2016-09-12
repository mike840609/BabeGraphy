//
//  like_users_VC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke
import SwiftyJSON

class LikeUsersVC: UITableViewController {
    
    var feedController: FeedController?
    
    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        
        let user = users[indexPath.item]
        
        cell.user = user
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UserCell
        
        
        guard let user_id  = NSUserDefaults.standardUserDefaults().stringForKey(USER_ID) else {return}
        
        // print(user_id)
        // print(cell?.user?.user_id)
        // print("-------------------")
        
        if cell?.user?.user_id == user_id{
            
            let destination = self.feedController!.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
//             let navigationController = UINavigationController(rootViewController: destination)
            self.feedController?.navigationController?.pushViewController(destination, animated: true)
            
        }else{
            
            guard let id = cell?.user?.user_id else{ return }
            guard let img = cell?.user?.user_imgurl else{ return }
            guard let name = cell?.user?.user_name else{ return }
            
            
            let user_data:[String: AnyObject] = [
                "user_id" : id,
                "profile_picture" : img,
                "username" : name
            ]
            
            let user_json = SwiftyJSON.JSON(user_data)
            
            // 把要造訪的user 直接 append 到陣列中 供後面 guestVC用
            
            guestJSON.append(user_json)
            
            
            
            let destination = self.feedController!.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
//            let navigationController = UINavigationController(rootViewController: destination)
            self.feedController?.navigationController?.pushViewController(destination, animated: true)
            
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    
    
}
