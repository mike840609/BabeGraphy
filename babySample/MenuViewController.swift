//
//  MenuViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Foundation


class MenuViewController: UIViewController , GuillotineMenu{

    var dismissButton: UIButton!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = UIButton(frame: CGRectZero)
        dismissButton.setImage(UIImage(named: "ic_menu"), forState: .Normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1;
        titleLabel.text = "Baby Menu"
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit()
    }
    
    @IBAction func infoClick(sender: AnyObject) {
        
        let baby_InfoVC = self.storyboard?.instantiateViewControllerWithIdentifier("BabyInfoVC") as! BabyInfoVC
        
        self.presentViewController(baby_InfoVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func createClick(sender: AnyObject) {
        
 
        let baby_CreateVC = self.storyboard?.instantiateViewControllerWithIdentifier("BabyCreateVC") as! BabyCreateVC
        
        
        self.presentViewController(baby_CreateVC, animated: true, completion: nil)
    }
    
    
    @IBAction func editClick(sender: AnyObject) {
        
    }
    
    @IBAction func deleteClick(sender: AnyObject) {
        
    }
    
    @IBAction func closeClick(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissButtonTapped(sende: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


// MARK : - MenuDelegate
extension MenuViewController: GuillotineAnimationDelegate {
    func animatorDidFinishPresentation(animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
