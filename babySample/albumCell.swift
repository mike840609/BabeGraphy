//
//  albumCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class albumCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var createLbl: UILabel!
    @IBOutlet weak var pdfLbl: UILabel!


    var album : Album? {
        didSet{
            self.nameLbl.text = album?._id
            self.createLbl.text = album?.created_at
            self.pdfLbl.text = album?.pdf_url
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
