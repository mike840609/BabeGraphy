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
    
    @IBOutlet weak var avaImg: UIImageView!
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
     
        let avaUrl = user!["data"][0]["avatar"].string
        avaImg.hnk_setImageFromURL(NSURL(string: avaUrl!)!)
        
    }
    
}
