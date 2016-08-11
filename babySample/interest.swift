//
//  interest.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke

class Interest
{
    // MARK: - Public API
    var title = ""
    var description = ""
    var numberOfMembers = 0
    var numberOfPosts = 0
    var featuredImage : NSURL?
    
    init(title: String, description: String, featuredImage: String)
    {
        self.title = title
        self.description = description
        self.featuredImage = NSURL(string:featuredImage)
        numberOfMembers = 1
        numberOfPosts = 1
    }
    
    
    
    // MARK: - Private
    // dummy data
    static func createInterests() -> [Interest]
    {
        return [
            Interest(title: "We Love Traveling Around the World", description: "We love backpack and adventures! We walked to Antartica yesterday, and camped with some cute pinguines, and talked about this wonderful app idea. 🐧⛺️✨", featuredImage: "http://www.bayuche.com/uploads/files/image/image/200907071143181890.jpg"),
            Interest(title: "Romance Stories", description: "We love romantic stories. We walked to Antartica yesterday, and camped with some cute pinguines, and talked about this wonderful app idea. 🐧⛺️✨", featuredImage: "http://i.telegraph.co.uk/multimedia/archive/02464/baby_2464393b.jpg"),
            Interest(title: "iOS Dev", description: "Create beautiful apps. We walked to Antartica yesterday, and camped with some cute pinguines, and talked about this wonderful app idea. 🐧⛺️✨", featuredImage:"http://www.thebabyshows.com/images/baby-landing.png"),
            Interest(title: "Race", description: "Cars and aircrafts and boats and sky. We walked to Antartica yesterday, and camped with some cute pinguines, and talked about this wonderful app idea. 🐧⛺️✨", featuredImage: "http://media.irishcentral.com/images/MI+Baby+brown+hair+blue+eyes+Irish+baby+names+iStock.jpg"),
            Interest(title: "Personal Development", description: "Meet life with full presence. We walked to Antartica yesterday, and camped with some cute pinguines, and talked about this wonderful app idea. 🐧⛺️✨", featuredImage: "http://gb.cri.cn/mmsource/images/2010/11/01/21/1770902844571060725.jpg"),
            Interest(title: "Reading News", description: "Get up to date with breaking-news. We walked to Antartica yesterday, and camped with some cute pinguines, and talked about this wonderful app idea. 🐧⛺️✨", featuredImage: "http://gd3.alicdn.com/bao/uploaded/i3/TB1cH8QIVXXXXXUaXXXXXXXXXXX_!!0-item_pic.jpg_400x400.jpg"),
        ]
    }
    /*
     
     */
}