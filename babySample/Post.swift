//
//  Post.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class Post{
    
    var author_name:String?
    var author_imgurl:String?
    var author_id:String?
    
    var content:String?
    var imgurl:String?
    
    var numLikes:Int?
    var numComments:Int?

    
    var location: Location?

    var created_at:String?
    var updated_at:String?
    
    // post id
    var _id:String?
    
    //store who say this like
    var likes_Users:[User] = [User]()
}

class Location: NSObject {
    var city: String?
    var state: String?
}


class User:NSObject{
    var user_id:String?
    var user_name:String?
    var user_imgurl:String?
}