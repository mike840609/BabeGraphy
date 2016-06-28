//
//  Extensions.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import Foundation
import UIKit

//  MARK: - FontColor
extension UIColor{
    
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255 ,alpha:1)
    }
}

//  MARK: - Autolayout
extension UIView{
    
    // 不限定傳入參數個數
    func addConstraintWithFormat(format:String,views:UIView...){
        
        var viewsDictionary = [String:UIView]()
        
        for (index,view) in views.enumerate(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}