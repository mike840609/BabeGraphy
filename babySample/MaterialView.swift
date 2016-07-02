//
//  MaterialView.swift
//  SocialNetwork
//
//  Created by 蔡鈞 on 2016/3/20.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        
        //將UIColor 轉型為 CGColor 因為 shadowColor 是 CGColor
        layer.shadowColor = UIColor(red: 157.0 / 255.0, green: 157.0 / 255.0, blue: 157.0 / 255.0, alpha: 0.5).CGColor
        
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
        
    }

}
