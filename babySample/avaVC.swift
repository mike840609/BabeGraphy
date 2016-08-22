//
//  avaVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/15.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke

class avaVC: UIViewController {
    
    // url temp
    var avaUrl: String?
    var ava :UIImage?
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //        backgroundImg.hnk_setImageFromURL(NSURL(string: avaUrl!)!)
        
        if let ava = ava{
            avaImg.image = ava
        }
        
        
        
        /*
        if let url = avaUrl  {
            //avaImg.hnk_setImageFromURL(NSURL(string:url)!)
            
            let url = NSURL(string: url)
            
            // 非同步載入
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    self.avaImg.image = UIImage(data: data!)
                });
            }
        */
        }
 
        
}