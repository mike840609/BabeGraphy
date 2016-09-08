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
import PeekPop



// 儲存用戶名的陣列
var guestID = [String]()
var guestJSON : Array<SwiftyJSON.JSON> = []


private let reuseIdentifier = "Cell"


class guestVC: UICollectionViewController ,PeekPopPreviewingDelegate{
    
    var refresher: UIRefreshControl!
    
    // 載入counter
    // var page:Int = 10
    
    // hold data from server
    var guest_posts: Array<SwiftyJSON.JSON> = []
    
    
    var peekPop: PeekPop?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.hidesBarsOnSwipe = true
        //        navigationController?.navigationBar.translucent = true
        
        // status bar background
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.67, alpha: 0.9)
        self.view.addSubview(view)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView!)
        
        
        // 該為使用者的資訊 user_id , profile_picture , username
        // print(guestJSON.last!["user_id"].string)
        
        setupView()
        
        // call load posts func
        loadPosts()
        
        // FollowingStatusCheck()
        
    }
    func setupView () {
        // CollectionView UI
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.backgroundColor = .whiteColor()
        
        // top title
        self.navigationItem.title = guestJSON.last!["username"].string
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named:"previous"), style: .Plain, target: self, action: #selector(guestVC.back(_:)))
        
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action:#selector(guestVC.back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(guestVC.refresh), forControlEvents: .ValueChanged)
        collectionView?.addSubview(refresher)
    }
    
    // back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewControllerAnimated(true)
        
        // 把當前這筆使用者資料從陣列清除
        if !guestJSON.isEmpty{
            guestJSON.removeLast()
        }
        
    }
    
    
    // refresh function
    func refresh() {
        loadPosts()
        collectionView?.reloadData()
        
        refresher.endRefreshing()
    }
    
    var loadingStatus = false
    
    // 載入訪客貼文
    func loadPosts() {
        
        if loadingStatus {
            return
        }
        
        guard let guest_id = guestJSON.last!["user_id"].string else {return }
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){
        self.guest_posts.removeAll(keepCapacity: false)
        //}
        
        loadingStatus = true
        
        Alamofire.request(.POST, "http://140.136.155.143/api/post/searchbyid",parameters: ["id": guest_id]).responseJSON { (response) in
            switch response.result{
                
            case .Success( let json ):
                
                print("guest post====================================")
                
                let json = SwiftyJSON.JSON(json)
                
                let lastItem = self.guest_posts.count
                
                for (_,subJson):(String , SwiftyJSON.JSON) in json{
                    self.guest_posts.append(subJson)
                    print(subJson)
                }
                
                let indexPaths = (lastItem..<self.guest_posts.count).map{NSIndexPath(forItem: $0, inSection: 0 )}
                
                self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                print("=====================================================\n\n")
                
                
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
        self.loadingStatus = false
    }
    
    // 往下載入
    func loadMore() {
        
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guest_posts.count
    }
    
    // Customer func - cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemWidth = (view.bounds.size.width - 5) / 3
        let size = CGSize(width: itemWidth, height: itemWidth)
        return size
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoBrowserCell", forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.imageView.image = nil
        
        let imageURL = self.guest_posts[indexPath.item]["small_imgurl"].string
        
        if let url = imageURL{
            cell.imageView.hnk_setImageFromURLAutoSize(NSURL(string: url)!)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let postVC = PostVC()
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    // MARK: UICollectionView Header
    // header View
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
         let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        // guest user id
        if let id = guestJSON.last!["user_id"].string {
           
            Alamofire.request(.GET, "http://140.136.155.143/api/user/id/\(id)").validate().responseJSON { (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    
                    print("guestUserIfon:\n",json)
                    
                    let json = SwiftyJSON.JSON(json)
                    
                    header.fullnameLbl.text = json[JSON_NAME].stringValue.uppercaseString
                    header.followers.text = json[JSON_FOLLOWER].stringValue
                    header.followings.text = json[JSON_FOLLOWEING].stringValue
                    header.posts.text = json[JSON_POST].stringValue
                    
                    if let url = json["avatar"].string {
                        header.avaImg.hnk_setImageFromURL(NSURL(string: url)!)
                    }
                    
                    
                    header.bioLbl.text = json["userbio"].stringValue
                    header.webTxt.text = json["userweb"].stringValue
                    
                    print("-------------------------------------------")
                    
                    
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
            
        
        }
        
        
        return header
    }
    
    
    
    // MARK: - Customer function
    // 回到最上方
    func postsTap(){
        
        if !guest_posts.isEmpty{
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
    
    func reload(notification:NSNotification){
        collectionView?.reloadData()
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

extension guestVC {
    
    // MARK: PeekPopPreviewingDelegate
    func previewingContext(previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        
        if let previewViewController = storyboard.instantiateViewControllerWithIdentifier("PreviewViewController") as? PreviewViewController {
            
            if let indexPath = collectionView!.indexPathForItemAtPoint(location) {
                
                
                
                if let layoutAttributes = collectionView!.layoutAttributesForItemAtIndexPath(indexPath) {
                    previewingContext.sourceRect = layoutAttributes.frame
                }
                
                let imageURL = self.guest_posts[indexPath.item]["imgurl"].string
                
                previewViewController.imageView.hnk_setImageFromURLAutoSize(NSURL(string: imageURL!)!)
                
                return previewViewController
            }
        }
        return nil
    }
    
    func previewingContext(previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
    
}
