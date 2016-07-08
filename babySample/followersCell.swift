//
//  followersCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/8.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    @IBAction func followBtn_click(sender: AnyObject) {
        
        let title = followBtn.titleForState(.Normal)
        
        // 
        if title == "FOLLOW"{
            
        }else{
            
        }
        
    }

}
