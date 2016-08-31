//
//  navVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // title color
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // button tint color
        self.navigationBar.tintColor = .whiteColor()

        
        // backgroung color
        self.navigationBar.barTintColor = UIColor(red: 1.0, green: 0.5, blue: 0.67, alpha: 0.3)
        
        // alpha
        self.navigationBar.translucent = true

        
    }
    
//    // white status bar function
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }



}
