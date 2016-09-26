//
//  ViewController.swift
//  sub_project
//
//  Created by 蔡鈞 on 2016/9/14.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit


class ViewController: SwipeViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let VC1 = UIViewController()
    let VC2 = UIViewController()
    let VC3 = UIViewController()
    
    var didSetupConstraints = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateViewConstraints()
    }
    
    
    
    
    func setupView() {
        
        
        VC1.view.backgroundColor =  UIColor(white: 0.95, alpha: 1)
        // VC1.title = "Page 1"
    
        VC2.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        // VC2.title = "Page 2"
        
        VC3.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        // VC3.title = "Page 3"
        
        setViewControllerArray([VC1, VC2, VC3])
        setFirstViewController(0)
        
        
    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
        
            
            let  box :UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: "Baby.jpg")
                imageView.translatesAutoresizingMaskIntoConstraints = true
                imageView.contentMode = .ScaleAspectFill
                
                 imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
                
                imageView.userInteractionEnabled = true
                
                return imageView
            }()
            
            let box2:UIImageView = {
                
                let imageView = UIImageView()
                imageView.image = UIImage(named: "MW-BZ111_cute_b_MG_20140411074006.jpg")
                imageView.translatesAutoresizingMaskIntoConstraints = true
                imageView.contentMode = .ScaleAspectFill
                
                 imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
                imageView.userInteractionEnabled = true
                
                return imageView
            }()
            
            
            VC1.view.addSubview(box)
            VC1.view.addSubview(box2)
            
            
            box.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(VC1.view).offset(40)
                make.left.equalTo(VC1.view).offset(20)
                make.right.equalTo(VC1.view).offset(-20)
                make.bottom.equalTo(VC1.view).offset(-400)
            }
            
            
            box2.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(VC1.view).offset(400)
                make.left.equalTo(VC1.view).offset(20)
                make.right.equalTo(VC1.view).offset(-20)
                make.bottom.equalTo(VC1.view).offset(-80)
            }

            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }

    
    
    
    func push(sender: UIBarButtonItem) {
        let VC4 = UIViewController()
        VC4.view.backgroundColor = UIColor.purpleColor()
        VC4.title = "Cool"
        self.pushViewController(VC4, animated: true)
    }
    
    
}

