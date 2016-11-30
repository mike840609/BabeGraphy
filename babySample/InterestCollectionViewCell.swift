//
//  InterestCollectionViewCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke

class InterestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public API 設值屬性
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    
    private func updateUI()
    {
        interestTitleLabel?.text! = interest.title
        
        // featuredImageView.hnk_setImageFromURL(interest.featuredImage!)
        featuredImageView.image = UIImage(named: (interest.featuredImage?.absoluteString)!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
}
