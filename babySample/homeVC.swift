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
import PeekPop
import Spring

// 儲存個人資訊 直接將整筆 json 存下來
var user : SwiftyJSON.JSON?

// temp image
var tempimage:UIImage?

class homeVC: UICollectionViewController ,UICollectionViewDelegateFlowLayout ,PeekPopPreviewingDelegate{
    
    var peekPop: PeekPop?
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    
    // 共用變數
    static let shareInstance = homeVC()
    
    
    // 存每一篇po 文的屬性 comment & comment user property
    var posts = [Post]()
    
    // pull to refresher
    var refresher:UIRefreshControl!
    
    
    // temp for segue uiimage
    var avaUrl :String?
    
    // identify
    let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //        navigationController?.hidesBarsOnSwipe = true
        //        navigationController?.navigationBar.translucent = true
        
        // status bar background
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.67, alpha: 0.9)
        self.view.addSubview(view)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 獲取所有使用者的貼文
        getPost(){ _ in}
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView!)
        
        setupView()
        
        
        // 更新通知 =====================================
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reload), name: "reload", object: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    
    
    // MARK: - UICollectionViewDataSource
    
    // header View
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        print(indexPath)
        
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
                
                //                header.posts.text = self.PostCount
                
                if let bio = json["data"][0][JSON_BIO].string{
                    header.bioLbl.text = bio
                }
                if let web = json["data"][0][JSON_WEB].string{
                    header.webTxt.text = web
                }
                
                // 解包圖片
                if let avaImg = json["data"][0]["avatar"].string{
                    
                    // 快取
                    header.avaImg.hnk_setImageFromURL(NSURL(string: avaImg)!)
                    self.avaUrl = avaImg
                    
                    // 非同步載入
                    /*
                     let url = NSURL(string: avaImg)
                     
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                     let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                     dispatch_async(dispatch_get_main_queue(), {
                     header.avaImg.image = UIImage(data: data!)
                     tempimage = UIImage(data: data!)
                     });
                     }
                     */
                }
                
                // 設定navigation 標題
                self.navigationItem.title = name.uppercaseString
                
                // 存取 user id 以供未來使用
                NSUserDefaults.standardUserDefaults().setObject(id, forKey:USER_ID)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // follower 亂跳問題
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
        return posts.count
    }
    
    
    // config cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.imageView.image = nil
        
        
        let imageURL = self.posts[indexPath.item].small_imgurl
        
        
        if let url = imageURL{
            cell.imageView.hnk_setImageFromURLAutoSize(NSURL(string: url)!)
        }
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // segue to post VC
        //
        //        let postVC = self.storyboard?.instantiateViewControllerWithIdentifier("PostVC") as! PostVC
        //        postVC.post = posts[indexPath.item]
        //        self.navigationController?.pushViewController(postVC, animated: true)
        //
        
        // segue to post_comment
        let postVC = self.storyboard?.instantiateViewControllerWithIdentifier("post_comment") as! post_comment
        postVC.post = posts[indexPath.item]
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = cell as! PhotoBrowserCollectionViewCell
        
        cell.imageView.animation = "zoomIn"
        //        cell.imageView.animation = "fadeInUp"
        cell.imageView.curve = "easeIn"
        cell.imageView.duration = 3
        cell.imageView.scaleX = 5.0
        cell.imageView.scaleY = 5.0
        
        cell.imageView.animate()
        
    }
    
    // MARK: - Customer Function
    
    func reload(notification:NSNotification){
        collectionView?.reloadData()
    }
    
    
    // 更新 collectionView 並停止更新動畫
    func refresh(){
        
        // 更新 user_posts 陣列資料 而後再刷新 collection view
        self.getPost(){_ in }
        
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    
    var loadingStatus = false
    
    // user po 文
    func getPost(completion:(Int) -> ()){
        
        if loadingStatus {
            return
        }
        
        loadingStatus = true
        
        // 抓不到token ,token過期 ,重新登入一次
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {
            
            // 重複登入 轉跳 登入頁面
            let alertVC = PMAlertController(title: "重複登入", description: "您的帳號已經從遠方登入,請重新登入", image: UIImage(named: "warning.png"), style: .Alert)
            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{self.logout()}))
            self.presentViewController(alertVC, animated: true, completion:nil)
            
        }
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){
        //        self.user_posts.removeAll(keepCapacity: false)
        self.posts.removeAll(keepCapacity: false)
        //}
        
        
        // token 有抓到 向 server 請求
        Alamofire.request(.POST, "http://140.136.155.143/api/post/search",parameters:["token":AccessToken!]).validate().responseJSON{ (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
                
                print("user's post=====================================================")
                
                
                
                // =================================================================================
                for (_ ,subJson):(String, SwiftyJSON.JSON) in json {
                    
                    let post = Post()
                    
                    post.author_name = subJson["author_name"].string
                    post.author_imgurl = subJson["author_imgurl"].string
                    post.author_id = subJson["author_id"].string
                    
                    post.created_at = subJson["created_at"].string
                    post.updated_at = subJson["updated_at"].string
                    
                    post.content = subJson["content"].string
                    post.small_imgurl = subJson["small_imgurl"].string
                    post.imgurl = subJson["imgurl"].string
                    post._id = subJson["_id"].string
                    
                    
                    // post.numLikes = subJson["likes_count"].int  == nil ? 0 : subJson["likes_count"].int
                    post.numComments = subJson["comments"].int == nil ? 0 : subJson["comments"].int
                    
                    // 串 likes 的 user
                    for (_ ,sub):(String, SwiftyJSON.JSON) in subJson["likes"]{
                        
                        // print(sub)
                        
                        let user = User()
                        user.user_id = sub["user_id"].string
                        user.user_name = sub["user_name"].string
                        user.user_imgurl = sub["user_avatar"].string
                        
                        post.likes_Users.append(user)
                    }
                    
                    // 串 comment 的 user
                    for (_ ,sub):(String, SwiftyJSON.JSON) in subJson["comments"]{
                        
                        let comment = Comment()
                        comment.user_id = sub["user_id"].string
                        comment.user_name = sub["user_name"].string
                        comment.user_avatar = sub["user_avatar"].string
                        comment.content = sub["content"].string
                        
                        post.comment_Users.append(comment)
                    }
                    
                    
                    
                    post.numLikes = post.likes_Users.count
                    post.numComments = post.comment_Users.count
                    
                    self.posts.append(post)
                    
                    
                }
                
                // ==================
                
                self.collectionView?.reloadData()
                
                //let indexPaths = (lastItem..<self.user_posts.count).map {NSIndexPath(forItem: $0, inSection: 0)}
                //self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                
                print("all user's post:" , self.posts.count)
                print("=====================================================\n\n")
                
                completion(json.count)
                
                
                
                
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
        
        self.loadingStatus = false
        
    }
    
    
    
    // 點擊回到 index 0
    func postsTap() {
        if !posts.isEmpty {
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
//        ava.ava = tempimage
        
        ava.avaUrl = self.avaUrl
        
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
        
        // 清空server token id
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(USER_ID)
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
    
    // MARK: PeekPopPreviewingDelegate
    func previewingContext(previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        
        if let previewViewController = storyboard.instantiateViewControllerWithIdentifier("PreviewViewController") as? PreviewViewController {
            
            if let indexPath = collectionView!.indexPathForItemAtPoint(location) {
                
                
                if let layoutAttributes = collectionView!.layoutAttributesForItemAtIndexPath(indexPath) {
                    previewingContext.sourceRect = layoutAttributes.frame
                }
                
                if  let imageURL = self.posts[indexPath.item].imgurl {
                    
                    previewViewController.imageView.hnk_setImageFromURLAutoSize(NSURL(string: imageURL)!)
                    
                }
                
                return previewViewController
            }
        }
        return nil
    }
    
    func previewingContext(previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
}




// MARK: - CollectionViewCell
class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: SpringImageView!
    
    var post: Post?
    
    var request:Alamofire.Request?      //用此屬性來儲存Alamofire得請求來載入圖片
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        imageView.frame = bounds
        addSubview(imageView)
    }
}