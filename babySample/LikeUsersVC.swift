//
//  like_users_VC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke

class LikeUsersVC: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        
        let user = users[indexPath.item]
        cell.textLabel?.text = user.user_name
        cell.detailTextLabel?.text = user.user_id
        
        if let profileImageUrl = user.user_imgurl{
            cell.profileImageView.hnk_setImageFromURLAutoSize(NSURL(string: profileImageUrl)!)
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
}
