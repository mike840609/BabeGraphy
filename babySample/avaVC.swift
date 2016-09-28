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
        
        if let url = avaUrl{
            avaImg.hnk_setImageStringFromURLAutoSize(url)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        // 清空緩存
        avaUrl = nil
    }
    
    
}