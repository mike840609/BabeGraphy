//
//  test.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/29.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Haneke

class PreviewViewController: UIViewController {
    
    var imageView = UIImageView()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "test"
        
        imageView.contentMode = .ScaleAspectFill
        self.view.addSubview(imageView)
    }
    
}
