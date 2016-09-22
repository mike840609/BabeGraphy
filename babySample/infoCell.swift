//
//  infoCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/22.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke

class infoCell: UITableViewCell {

    
    @IBOutlet weak var avaImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var bloodLbl:UILabel!
    @IBOutlet weak var birthLbl:UILabel!
    
    
    var baby:Baby?{
        didSet{
            
            if let url = baby?.small_imgurl{
                avaImg.hnk_setImageStringFromURLAutoSize(url)
            }
            
            if let name = baby?.baby_name{
                nameLbl.text = name
            }
            
            if let blood = baby?.baby_blood{
                bloodLbl.text = blood
            }
            if let birth = baby?.baby_birth{
                birthLbl.text = birth
            }
            
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // CORNER RTADIUS
        avaImg.contentMode = .ScaleAspectFill
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
