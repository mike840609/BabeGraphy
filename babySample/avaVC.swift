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
    
    
    @IBOutlet weak var avaImg: UIImageView!
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        avaImg.hnk_setImageFromURL(NSURL(string: avaUrl!)!)
    }
    
}
