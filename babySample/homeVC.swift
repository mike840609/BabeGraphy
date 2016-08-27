//
//  homeVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/30.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PMAlertController
import FBSDKCoreKit
import FBSDKLoginKit
import Haneke


// 儲存個人資訊 直接將整筆 json 存下來
var user : SwiftyJSON.JSON?

// temp image
var tempimage:UIImage?

class homeVC: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    // 儲存照片
    var picArray = [String]()
    
    // user's posts
    var user_posts: Array<SwiftyJSON.JSON> = []
    
    
    // pull to refresher
    var refresher:UIRefreshControl!
    
    // identify
    let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        // 獲取所有使用者的貼文
        getPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        // 更新通知 =====================================
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reload), name: "reload", object: nil)
        
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    // header View
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        // 抓不到token ,token過期 ,重新登入一次
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {
            
            // 重複登入 轉跳 登入頁面
            let alertVC = PMAlertController(title: "重複登入", description: "您的帳號已經從遠方登入,請重新登入", image: UIImage(named: "warning.png"), style: .Alert)
            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{self.logout()}))
            self.presentViewController(alertVC, animated: true, completion:nil)
            
        }
        
        
        // token 有抓到 向 server 請求
        Alamofire.request(.GET, "http://140.136.155.143/api/user/token/\(AccessToken!)").validate().responseJSON{ (response) in
            
            switch response.result{
            case .Success(let json):
                
                
                let json = SwiftyJSON.JSON(json)
                
                user = json
                
                // optional chainging
                guard let id:String = json["data"][0][JSON_ID].string,
                    let name:String = json["data"][0][JSON_NAME].string,
                    let email:String = json["data"][0][JSON_EMAIL].string,
                    let follower_count:Int = json["data"][0][JSON_FOLLOWER].int,
                    let following_count:Int = json["data"][0][JSON_FOLLOWEING].int,
                    let posts_count:Int = json["data"][0][JSON_POST].int
                    else {
                        
                        // 重複登入 轉跳 登入頁面
                        let alertVC = PMAlertController(title: "重複登入", description: "您的帳號已經從遠方登入,請重新登入", image: UIImage(named: "warning.png"), style: .Alert)
                        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{self.logout()}))
                        self.presentViewController(alertVC, animated: true, completion:nil)
                        break
                }
                
                
                header.fullnameLbl.text = name.uppercaseString
                header.followers.text = String(follower_count)
                header.followings.text = String(following_count)
                header.posts.text = String(posts_count)
                
                if let bio = json["data"][0][JSON_BIO].string{
                    header.bioLbl.text = bio
                }
                if let web = json["data"][0][JSON_WEB].string{
                    header.webTxt.text = web
                }
                
                // 解包圖片
                if let avaImg = json["data"][0]["avatar"].string{
                    // 快取
                    // header.avaImg.hnk_setImageFromURL(NSURL(string: avaImg)!)
                    
                    // 非同步載入
                    let url = NSURL(string: avaImg)
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                        dispatch_async(dispatch_get_main_queue(), {
                            header.avaImg.image = UIImage(data: data!)
                            tempimage = UIImage(data: data!)
                        });
                    }
                }
                
                // 設定navigation 標題
                self.navigationItem.title = name.uppercaseString
                
                // 存取 user id 以供未來使用
                NSUserDefaults.standardUserDefaults().setObject(id, forKey:USER_ID)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                print(" id:\(id)\n name:\(name)\n email:\(email)\n posts:\(posts_count)\n follower:\(follower_count)\n following:\(following_count)")
                
                
                // self.getInfo()
                
            case .Failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        
        // 添加手勢 postBtn , followerBtn ,followingBtn
        
        // tap post
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.userInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        
        // tap following
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followingTap))
        followingTap.numberOfTapsRequired = 1
        header.followings.userInteractionEnabled = true
        header.followings.addGestureRecognizer(followingTap)
        
        // show img
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.avaTap))
        avaTap.numberOfTapsRequired = 1
        header.avaImg.userInteractionEnabled = true
        header.avaImg.addGestureRecognizer(avaTap)
        
        return header
    }
    
    
    
    
    // Customer func - cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemWidth = (view.bounds.size.width - 5) / 3

        
        let size = CGSize(width: itemWidth, height: itemWidth)
        
        return size
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user_posts.count
    }
    
    
    // config cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.imageView.image = nil
        
//        let imageURL = self.user_posts[indexPath.item]["imgurl"].string
        let imageURL = self.user_posts[indexPath.item]["small_imgurl"].string
        
        
        if let url = imageURL{
            cell.imageView.hnk_setImageFromURLAutoSize(NSURL(string: url)!)
        }
        
        
        return cell
    }
    
    
    
    // MARK: - Customer Function
    
    func reload(notification:NSNotification){
        collectionView?.reloadData()
    }
    
    
    // 更新 collectionView 並停止更新動畫
    func refresh(){
        
        // 更新 user_posts 陣列資料 而後再刷新 collection view
        getPost()
        
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    
    // user po 文
    func getPost(){
        
        // 抓不到token ,token過期 ,重新登入一次
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {
            
            // 重複登入 轉跳 登入頁面
            let alertVC = PMAlertController(title: "重複登入", description: "您的帳號已經從遠方登入,請重新登入", image: UIImage(named: "warning.png"), style: .Alert)
            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{self.logout()}))
            self.presentViewController(alertVC, animated: true, completion:nil)
            
        }
        
        // token 有抓到 向 server 請求
        Alamofire.request(.POST, "http://140.136.155.143/api/post/search",parameters:["token":AccessToken!]).validate().responseJSON{ (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
                
                print("user's post=====================================================")
                
                self.user_posts.removeAll(keepCapacity: false)
                
                // 走訪陣列
                for (_,subJson):(String, SwiftyJSON.JSON) in json{
                    
                    self.user_posts.append(subJson)
                    print(subJson)
                    self.collectionView?.reloadData()
                    
                }
                
                print("all user's post:" , self.user_posts.count)
                print("=====================================================\n\n")
                
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    // 點擊回到 index 0
    func postsTap() {
        if !picArray.isEmpty {
            let index = NSIndexPath(forItem: 0 ,inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: .Top, animated: true)
        }
    }
    
    // 追蹤者 的 tableView
    func followersTap(){
        
        show = "followers"
        
        // instance storyboard
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // 追蹤中 的 tableView
    func followingTap(){
        
        show = "followings"
        
        // instance storyboard
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followings, animated: true)
        
    }
    
    
    func avaTap (){
        
        let ava = self.storyboard?.instantiateViewControllerWithIdentifier("avaVC") as! avaVC
        
        // image pass
        ava.ava = tempimage
        
        let navigationController = UINavigationController(rootViewController: ava)
        
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    // MARK: - IBAction
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
    }
    
    // logout all controller can use it
    func logout(){
        
        // 清空server token
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // facebook logout 暫時不清空 只單用server token 判斷
        
        
        
        // View Segue
        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
        
        
    }
    
    
    // MARK: - HELPER
    func setupView(){
        
        // alaways vertical
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        collectionView?.backgroundColor = .whiteColor()
        
        // logoutBtn Set
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        logoutBtn.setTitleTextAttributes(attributes, forState: .Normal)
        logoutBtn.title = String.fontAwesomeIconWithName(.SignOut)
        
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(homeVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        

        
    }
    
    
}


// MARK: - CollectionViewCell
class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    var request:Alamofire.Request?      //用此屬性來儲存Alamofire得請求來載入圖片
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        // imageView.frame = bounds
        addSubview(imageView)
    }
}