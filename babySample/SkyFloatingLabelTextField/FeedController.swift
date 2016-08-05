//
//  testCollectionViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import PMAlertController
import Haneke
import SwiftyJSON

private let reuseIdentifier = "Cell"
let posts = Posts()

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    // local var 第一優先權 測試用
    // var posts = [Post]()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Mark: - CollectionView Set
        navigationItem.title = "BabeGraphy"
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.collectionView!.registerClass(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        getFeedPost()
        
    }
    
    // release memory
    override func didReceiveMemoryWarning() {
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
        
      
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath]
        
        feedCell.feedController = self
        
        return feedCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = posts[indexPath].statusText{
            
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSizeMake(view.frame.width, rect.height + knownHeight + 16)
        }
        
        return CGSizeMake(view.frame.width, 500)
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
            
            //
            if let keyWindow = UIApplication.sharedApplication().keyWindow{
                
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRectMake(0, keyWindow.frame.height - 49, 1000, 49)
                tabBarCoverView.backgroundColor = UIColor.blackColor()
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
                
            }
            // Zoomin 動畫
            zoomImageView.backgroundColor = UIColor.redColor()
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
        
        Alamofire.request(.POST, "http://140.136.155.143/api/post/feed",parameters: ["token":AccessToken!])
            .responseJSON { (response) in
                switch response.result{
                case .Success(let json):

                    
                    let json = SwiftyJSON.JSON(json)
                    
                    for (_,subJson):(String, SwiftyJSON.JSON) in json[0] {
                        
                        /*
                        let post = Post()
                        
                        post.name = subJson["author_name"].string
                        post.created_at = subJson["created_at"].string
                        post.statusText = subJson["content"].string
                        
                        post.numLikes = 1541
                        post.numComments = 124
                        
                        self.posts.append(post)
                        */
                        
                        print(subJson,"\n\n")
                        
                        
                    }

                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
                
        }
        collectionView?.reloadData()
        
    }
    
    
}

