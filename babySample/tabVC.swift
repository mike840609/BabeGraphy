//
//  tabVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class tabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // color of item
        
        // self.tabBar.tintColor = UIColor.rgb(0, green: 187, blue: 204)
        // self.tabBar.tintColor = UIColor(red: 0.10, green: 0.81, blue: 0.97, alpha: 1)
        // self.tabBar.tintColor = UIColor(red: 1.0, green: 0.11, blue: 0.68, alpha: 1)
        
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.5, blue: 0.73, alpha: 1)
        
        // color of background
        
        self.tabBar.translucent = true

     
    }
    
}
