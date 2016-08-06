//
//  guestVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/22.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PMAlertController
import Haneke


// 儲存用戶名的陣列
var guestname = [String]()
var guestJSON : Array<SwiftyJSON.JSON> = []


private let reuseIdentifier = "Cell"


class guestVC: UICollectionViewController {
    
    var refresher: UIRefreshControl!
    
    // 載入counter
    var page:Int = 10
    
    // hold data from server
    var postsJSON: Array<SwiftyJSON.JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 該為使用者的資訊 user_id , profile_picture , username
        print(guestJSON.last)
        
        // CollectionView UI
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.backgroundColor = .whiteColor()
        
        
        // top title
        self.navigationItem.title = guestJSON.last!["username"].string
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: #selector(guestVC.back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action:#selector(guestVC.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(guestVC.refresh), forControlEvents: .ValueChanged)
        collectionView?.addSubview(refresher)
        
        // call load posts func
        loadPosts()
        
//        FollowingStatusCheck()
        
    }
    
    
    // back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewControllerAnimated(true)
        
        //clean guest username or ddeduct the last guest username from guestname = Array
        if !guestname.isEmpty{
            guestname.removeLast()
        }
    }
    
    
    // refresh function
    func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    // 載入貼文
    func loadPosts() {
        
    }
    
    // 往下載入
    func loadMore() {
        
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsJSON.count
    }
    
    // Customer func - cell size
    
    /*
     func collectionView(collectionView: UICollectionView, layout collectionViewLayOut:UICollectionViewLayout , sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
     let size = CGSize(width: self.view.frame.width/3, height:  self.view.frame.width/3)
     return size
     
     }
     */
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        
        return cell
    }
    
    // MARK: UICollectionView Header
    
    // header View
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // guest user id
        let id = guestJSON.last!["user_id"].string
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        
        Alamofire.request(.GET, "http://140.136.155.143/api/user/id/\(id!)").validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                // print("guestUserIfon:\n",json)
                
                let json = SwiftyJSON.JSON(json)
                
                header.fullnameLbl.text = json[JSON_NAME].stringValue.uppercaseString
                header.followers.text = json[JSON_FOLLOWER].stringValue
                header.followings.text = json[JSON_FOLLOWEING].stringValue
                header.posts.text = json[JSON_POST].stringValue
                
                header.bioLbl.text = json["userbio"].stringValue
                header.webTxt.text = json["userweb"].stringValue
                

                
                
            case .Failure(let error):
                print(error.localizedDescription)
                
            }
            
            // 判斷追蹤按鈕 狀態
            self.FollowingStatusCheck(header)
            
//            if (self.FollowingStatusCheck()){
//                header.editBtn.setTitle("FOLLOWING", forState: .Normal)
//                header.editBtn.backgroundColor = UIColor.greenColor()
//            }else{
//                header.editBtn.setTitle("FOLLOW", forState: .Normal)
//                header.editBtn.backgroundColor = UIColor.lightGrayColor()
//            }
        }
        
        // 添加手勢 postBtn , followerBtn ,followingBtn
        
        // tap post
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(guestVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.userInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(guestVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        
        // tap following
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(guestVC.followingsTap))
        followingTap.numberOfTapsRequired = 1
        header.followings.userInteractionEnabled = true
        header.followings.addGestureRecognizer(followingTap)
        
        return header
    }
    
    
    
    // MARK: - Customer function
    // 回到最上方
    func postsTap(){
        
        if !postsJSON.isEmpty{
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: .Top, animated: true)
        }
    }
    
    // 進到 guest 的粉絲列表
    func followersTap(){
        
        user = guestJSON.last!
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // 進到 guest 的追蹤中列表
    func followingsTap(){
        user = guestJSON.last!
        show = "followings"
        
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    // 使用者是否追蹤此人 追蹤按鈕
    func FollowingStatusCheck(header:headerView) {
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_following",parameters:["token":AccessToken]).validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
                
                // guest
                let gusetId = guestJSON.last!["user_id"].string
                
                for (_,subJson):(String, SwiftyJSON.JSON) in json["data"] {
                    
                    // 找到追蹤者 改變旗標 並且 直接結束方法
                    if subJson["user_id"].string == gusetId{
                        print("following this user")
                        header.editBtn.setTitle("FOLLOWING", forState: .Normal)
                        header.editBtn.backgroundColor = UIColor.greenColor()
                        return
                    }
                }
                
            case .Failure(let error):
                print(error)
            }
        }
        
        
    }
    
    
}
