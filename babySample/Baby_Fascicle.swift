//
//  Baby_Fascicle.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON

class Baby_Fascicle: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // 存每一篇po 文的屬性 comment & comment user property
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    // MARK: - Customer function
    // 獲取 user's posts
    func getPosts (completion:() -> ()) {
        
        ApiService.shareInstance.getUser_post(){ json  in
            
            
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
    
    @IBAction func CreateBook(sender: AnyObject) {
        
        getPosts {
            
            let choiseVC = self.storyboard?.instantiateViewControllerWithIdentifier("multipleChoseVC") as! multipleChoseVC
            
            choiseVC.posts = self.posts
            
            self.navigationController?.pushViewController(choiseVC, animated: true)
            
        }
        
    }
    
    
    @IBAction func SearchBook(sender: AnyObject) {
        
        let albumSearchVC = self.storyboard?.instantiateViewControllerWithIdentifier("album_searchVC") as! album_searchVC
        
        self.navigationController?.pushViewController(albumSearchVC, animated: true)

        
    }
    
    
    @IBAction func dismissVC(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    
}
