//
//  ItemCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/20.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var commentLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var avaImg:UIImageView!
    
    var newsItem: NewsItem? {
        didSet {
            if let item = newsItem {
                nameLbl.text = item.category.toString()
                nameLbl.textColor = item.category.toColor()
                commentLbl.text = item.summary
            }
            else {
                nameLbl.text = nil
                commentLbl.text = nil
                timeLbl.text = nil
            }
        }
    }

    
    var comments:Comment? {
        didSet{
//            var user_avatar:String?
//            var content:String?
//            var user_id:String?
//            var user_name:String?
            
            // Set View when comment assigned

            if let name = comments?.user_name{
                nameLbl.text = name
            }
            
            if let ava = comments?.user_avatar{
                avaImg.hnk_setImageFromURL(NSURL(string: ava)!)
            }
            
            if let content = comments?.content{
                commentLbl.text = content
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avaImg.contentMode = .ScaleAspectFill
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reuse Function in this code section
    }

}
