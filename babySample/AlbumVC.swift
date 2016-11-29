//
//  AlbumVCViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlbumVC: UIViewController {
    
    // 存每一篇po 文的屬性 comment & comment user property
    var posts = [Post]()

    // MARK: - IBOutlet
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton:UIButton!
    @IBOutlet weak var currentUserFullNameButton:UIButton!
    
    // MenuBar
    @IBOutlet weak var leftBarButton: UIButton!
    
    private lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    
    // MARK: - UICollectionViewDataSource
    private var interests = Interest.createInterests()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Change the height for 3.5-inch screen
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
    }
    
    private struct Storyboard{
        static let CellIdentifier = "Cell"
    }
    
    @IBAction func showMenuAction(sender: UIButton) {
        
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("MenuViewController")
        menuVC.modalPresentationStyle = .Custom
        menuVC.transitioningDelegate = self
        if menuVC is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        }
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = sender
        presentationAnimator.duration = 0.4
        self.presentViewController(menuVC, animated: true, completion: nil)
        
    }
    
    
    
}

extension AlbumVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return interests.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        // 類別內設值屬性 自動賦值
        cell.interest = self.interests[indexPath.item]
        
        cell.layer.cornerRadius = 4.0

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.item)
        
        
        // 判斷基數偶數(基數同一模板 偶數 同一模板) 參數值
        templateItems = indexPath.item%2 == 0 ?  8 : 5
        
        
        
        // 選好模板好跳頁
        getPosts {
            let choiseVC = self.storyboard?.instantiateViewControllerWithIdentifier("multipleChoseVC") as! multipleChoseVC
            choiseVC.posts = self.posts
            self.navigationController?.pushViewController(choiseVC, animated: true)
        }
        
    }
    
    
    
    
    // get all posts
    func getPosts (completion:() -> ()) {
        
        ApiService.shareInstance.getUser_post(){ json  in
            
            // 先清空陣列
            self.posts.removeAll(keepCapacity: false)
            
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
                self.posts.append(post)
            }
            completion()
        }
    }
    
}

// 自動置中
extension AlbumVC : UIScrollViewDelegate {
    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
//        
//        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
//        
//        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//        
//        var offset = targetContentOffset.memory
//        
//        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
//        
//        let roundedIndex = round(index)
//        
//        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//        
//        targetContentOffset.memory = offset
//        
//    }
    
}


// MARK : - MenuDelegate
extension AlbumVC: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Presentation
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Dismissal
        return presentationAnimator
    }
}