//
//  followerVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

// 要顯示 storyBoardId
var show:String?

class followersVC: UITableViewController {
    
    var usernameArray = [String]()
    var avaArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = show?.uppercaseString
        
        if show == "followers"{
            loadFollowers()
        }
        
        if show == "following"{
            loadFollowings()
        }
        
        
    }

    // MARK: - Customer function
    func loadFollowers(){
        
    }
    
    func loadFollowings(){
        
    }
    

    // MARK: - Table view data source
    
    // cell height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //  320 / 4 = 80
        return self.view.frame.size.width / 4
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  usernameArray.count
    }

    

}
