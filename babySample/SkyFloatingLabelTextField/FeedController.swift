//
//  testCollectionViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import PMAlertController
import Haneke
import SwiftyJSON
import NVActivityIndicatorView
import SKPhotoBrowser

private let reuseIdentifier = "Cell"

// Global var
// var posts = [Post]()

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout ,SKPhotoBrowserDelegate{
    
    // local var 測試用
    var posts = [Post]()
    
    
    var refresher:UIRefreshControl!
    
    // 紀錄是否更新照片 以及正在瀏覽的頁面
    var populatingPhotos = false
    
    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"
    
    // MARK: - Life Cycle
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
        
        // 抓取動態牆資料
        
        self.getFeedPost()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        // Mark: - CollectionView Set
        navigationItem.title = "BabeGraphy"
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.collectionView!.registerClass(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 底部載入
        setFooterView()
        
        
        
    }
    
    
    // release memory
    override func didReceiveMemoryWarning() {
    }
    
    // MARK: scrollView
    // load more data
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8{
            loadmore()
        }
        
    }
    
    func loadmore (){
        
        if populatingPhotos {
            return
        }
        
        populatingPhotos = false
        
        // 載入更多資訊
        
        populatingPhotos = true
        
    }
    
    func setFooterView()  {
        
        let layout = UICollectionViewFlowLayout()
        layout.footerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100.0)
        collectionView!.collectionViewLayout = layout
        
        collectionView?.registerClass(PhotoBrowserCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, forIndexPath: indexPath) as UICollectionReusableView
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        
        feedCell.feedController = self
        
        
        // 滑動換頁
        //let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToChangeView))
        
        //swipeGesture.numberOfTouchesRequired = 1
        //swipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        //feedCell.addGestureRecognizer(swipeGesture)
        
        return feedCell
    }
    
    func swipeToChangeView() {
        print("123")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].content{
            
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 300 + 8 + 24 + 8 + 44
            
            return CGSizeMake(view.frame.width, rect.height + knownHeight + 16)
        }
        
        return CGSizeMake(view.frame.width, 300)
    }
    
    // 轉跳 相簿 下載
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FeedCell else {
            return
        }
        
        guard let originImage = cell.statusImg.image else {
            return
        }
        
        var images = [SKPhoto]()
        
        for post in posts{
            if let url = post.imgurl{
                let photo = SKPhoto.photoWithImageURL(url)
                photo.caption = post.content
                photo.shouldCachePhotoURLImage = false
                images.append(photo)
            }
        }
        
        
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: cell)
        
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        browser.displayDeleteButton = true
        browser.statusBarStyle = .LightContent
        browser.bounceAnimation = true
        
        // Can hide the action button by setting to false
        browser.displayAction = true
        
        
        presentViewController(browser, animated: true, completion: nil)
    }
    
    // Rotation autolayout
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    
    let blackBackgroundView = UIView()
    let zoomImageView = UIImageView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    var statusImageView: UIImageView?
    
    // 照片縮放動畫
    func animateImageView(statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convertRect(statusImageView.frame, toView: nil){
            
            // 原本的圖片隱藏
            statusImageView.alpha = 0
            
            // 改變背景
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.blackColor()
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            // 覆蓋navbar
            navBarCoverView.frame = CGRectMake(0, 0, 1000, 20+44)
            navBarCoverView.backgroundColor = UIColor.blackColor()
            navBarCoverView.alpha = 0
            
            
            if let keyWindow = UIApplication.sharedApplication().keyWindow{
                
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRectMake(0, keyWindow.frame.height - 49, 1000, 49)
                tabBarCoverView.backgroundColor = UIColor.blackColor()
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
                
            }
            // Zoomin 動畫
            // zoomImageView.backgroundColor = UIColor.redColor()
            zoomImageView.frame = startingFrame
            zoomImageView.userInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .ScaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            // zoomout 動畫
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            // 動畫
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
                
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRectMake(0, y, self.view.frame.width, height)
                
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
                
                }, completion: nil)
            
        }
    }
    
    func zoomOut() {
        
        if let startingFrame = statusImageView!.superview?.convertRect(statusImageView!.frame, toView: nil){
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
                
                // 漸變動畫
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
                
                }, completion: {
                    (didcomplete) in
                    
                    // 移除圖片 釋放記憶體
                    self.zoomImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    
                    // 還原原本圖片透明度
                    self.statusImageView?.alpha = 1
            })
            
        }
    }
    
    // GetFeedData
    func getFeedPost(){
        
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST, "http://140.136.155.143/api/post/feed",parameters: ["token":AccessToken!]).validate(statusCode: 200..<300)
            .responseJSON { (response) in
                
                switch response.result{
                case .Success(let json):
                    
                    self.posts.removeAll(keepCapacity: false)
                    
                    let json = SwiftyJSON.JSON(json)
                    
                    print(json)
                    print("============================================================================")
                    
                    for (_ ,subJson):(String, SwiftyJSON.JSON) in json {
                        
                        let post = Post()
                        
                        
                        post.author_name = subJson["author_name"].string
                        post.author_imgurl = subJson["author_imgurl"].string
                        post.author_id = subJson["author_id"].string
                        
                        post.created_at = subJson["created_at"].string
                        post.updated_at = subJson["updated_at"].string
                        
                        post.content = subJson["content"].string
                        post.imgurl = subJson["imgurl"].string
                        post._id = subJson["_id"].string
                        
                        
                        post.numLikes = subJson["likes"].int  == nil ? 0 : subJson["likes"].int
                        post.numComments = subJson["comments"].int == nil ? 0 : subJson["comments"].int
                        
                        
                        self.posts.append(post)
                        self.collectionView?.reloadData()
                    }
                    
                    // 排序先暫時用手機硬幹
                    self.posts.sortInPlace({ $0.created_at > $1.created_at })
                    
                    // self.collectionView?.reloadData()
                    
                case .Failure(let error):
                    
                    print(error.localizedDescription)
                    
                    // token 已經失效
                    if response.response?.statusCode == 500{
                        
                        let alertVC = PMAlertController(title: "重複登入", description: "您的帳號已經從遠方登入,請重新登入", image: UIImage(named: "warning.png"), style: .Alert)
                        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{self.logout()}))
                        self.presentViewController(alertVC, animated: true, completion:nil)
                        print("token failed")
                        
                        return
                        
                    }
                }
        }
    }
    
    func refresh(){
        getFeedPost()
        refresher.endRefreshing()
    }
    
    
    // footer loading
    class PhotoBrowserCollectionViewLoadingCell: UICollectionReusableView {
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            spinner.color = UIColor.grayColor()
            
            spinner.startAnimating()
            spinner.center = self.center
            addSubview(spinner)
        }
    }
    
    
    
}

extension FeedController{
    // logout all controller can use it
    func logout(){
        
        // 清空server token
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        // View Segue
        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
        
        
    }
}

//  MARK : - SKPhoto Delegate
extension FeedController{
    
    func didShowPhotoAtIndex(index: Int) {
        collectionView!.visibleCells().forEach({$0.hidden = false})
        collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willDismissAtPageIndex(index: Int) {
        collectionView!.visibleCells().forEach({$0.hidden = false})
        collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willShowActionSheet(photoIndex: Int) {
        // do some handle if you need
    }
    
    func didDismissAtPageIndex(index: Int) {
        collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
    
    func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void)) {
        reload()
    }
    
    func viewForPhoto(browser: SKPhotoBrowser, index: Int) -> UIView? {
        
        return collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

