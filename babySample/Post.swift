//
//  Post.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class Post{
    var name:String?
    var profileImageName:String?
    var statusText:String?
    var statusImageName:String?
    var numLikes:Int?
    var numComments:Int?
    var statusImgUrl:String?
    var location: Location?
    
    
    var created_at:String?
    
    
    
}

class Location: NSObject {
    var city: String?
    var state: String?
}


//class Posts {
//    
//    private let postsList: [Post]
//    
//    init() {
//        
//        
//        // Mark: - Post Set
//        let postMark = Post()
//        postMark.name = "Mark Zuckerberg"
//        postMark.statusText = "Today is a good day."
//        postMark.profileImageName = "zuckprofile"
//        postMark.numLikes = 1541
//        postMark.numComments = 124
//        postMark.statusImgUrl = "https://scontent-tpe1-1.xx.fbcdn.net/t31.0-8/10572129_10102573718893501_5066514421043057986_o.jpg"
//        
//        
//        let postMike = Post()
//        postMike.name = "Mike Tsai"
//        postMike.statusText = "Apple's operating system for iPhones and iPads has gone largely without design changes since iOS 7, so it's reasonable to assume iOS 10 may feature some design tweaks to update the look of the OS. A dark mode is one possibility that's been circulating based on the look of Apple's WWDC app and site, but there's no evidence suggesting such a feature will be implemented."
//        postMike.profileImageName = "tsai"
//        postMike.numLikes = 151
//        postMike.numComments = 25
//        postMike.statusImgUrl = "http://unlimiteddonuts.com/wp-content/uploads/2015/02/homer-simpson.jpg"
//        
//        
//
//        
//        postsList = [postMark,postMike]
//    }
//    
//    func numberOfPosts() -> Int {
//        return postsList.count
//    }
//
//    subscript(indexPath: NSIndexPath) -> Post {
//        get {
//            return postsList[indexPath.item]
//        }
//    }
//
//}