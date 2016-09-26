//
//  medicineCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class medicineCell: UITableViewCell {
    
    var medicine :Medicine?{
        didSet{
            chnLbl.text = medicine?.vaccine_chi
            engLbl.text = medicine?.vaccine_eng
            numberLbl.text = medicine?.number
            timeLbl.text = medicine?.time
        }
    }

    @IBOutlet weak var chnLbl:UILabel!
    @IBOutlet weak var engLbl:UILabel!
    @IBOutlet weak var numberLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
