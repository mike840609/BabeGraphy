//
//  homeVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/30.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit


class homeVC: UICollectionViewController {
    
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // alaways vertical
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        collectionView?.backgroundColor = .whiteColor()
        
        //
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        logoutBtn.setTitleTextAttributes(attributes, forState: .Normal)
        logoutBtn.title = String.fontAwesomeIconWithName(.SignOut)
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    // header
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        return header
    }
    
    
    // Customer func - cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayOut:UICollectionViewLayout , sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
        
        let size = CGSize(width: self.view.frame.width/3, height:  self.view.frame.width/3)
        return size
        
    }
    
    // config cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
    }
    
    
    
}
