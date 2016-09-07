//
//  BabyCreateController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class BabyCreateController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let birthTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Birth"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let birthSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bloodTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Blood"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        
        // imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.userInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var CreateButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        // button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.backgroundColor = UIColor(red:0.472, green:0.788, blue:0.896, alpha:0.95)
        
        view.addSubview(inputsContainerView)
        view.addSubview(profileImageView)
        view.addSubview(CreateButton)
        
        setupInputsContainerView()
        setupCreateButton()
        setupProfileImageView()
        
    }
    
    
    // 存 input高 , 供外方法使用
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor : NSLayoutConstraint?
    var birthTextFieldHeightAnchor : NSLayoutConstraint?
    var bloodTextFieldHeightAnchor : NSLayoutConstraint?
    
    func setupInputsContainerView(){
        
        
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
        inputContainerViewHeightAnchor?.active = true
        
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(birthTextField)
        inputsContainerView.addSubview(birthSeparatorView)
        inputsContainerView.addSubview(bloodTextField)
        
        
        // setTextView
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        
        birthTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        birthTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        
        birthTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        
        birthTextFieldHeightAnchor = birthTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        birthTextFieldHeightAnchor?.active = true
        
        //need x, y, width, height constraints
        birthSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        birthSeparatorView.topAnchor.constraintEqualToAnchor(birthTextField.bottomAnchor).active = true
        birthSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        birthSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        bloodTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        bloodTextField.topAnchor.constraintEqualToAnchor(birthSeparatorView.bottomAnchor).active = true
        
        bloodTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        bloodTextFieldHeightAnchor = bloodTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        bloodTextFieldHeightAnchor?.active = true
        
    }
    
    func setupCreateButton(){
        CreateButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        CreateButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        CreateButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        CreateButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func setupProfileImageView(){
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    
}
