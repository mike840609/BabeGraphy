//
//  Extensions.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import Foundation
import UIKit
import Haneke

//  MARK: - FontColor
extension UIColor{
    
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255 ,alpha:1)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
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

// MARK: - hnk
// MARK: - Autolayoutextention
// UIImageView 自動大小(程式碼佈局) haneke_swift
extension UIImageView {
    
    func hnk_setImageFromURLAutoSize(url: NSURL) {
        var format: Format<UIImage>? = nil
        if frame.size == CGSize.zero {
            format = Format<UIImage>(name: "original")
        }
        // 先清空圖片 避免reuse cell 時 有之前的圖片
        image = nil
        hnk_setImageFromURL(url, format: format)
    }
    
    func hnk_setImageStringFromURLAutoSize(url: String)  {
        
        var format: Format<UIImage>? = nil
        if frame.size == CGSize.zero {
            format = Format<UIImage>(name: "original")
        }
        // 先清空圖片 避免reuse cell 時 有之前的圖片
        image = nil
        
        hnk_setImageFromURL(NSURL(string: url)!, format: format)
        
    }
}



// 時間換算
extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyyMMdd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "fr_CH_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}



// Core Data
extension UIViewController {
    var appDelegate:AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
}