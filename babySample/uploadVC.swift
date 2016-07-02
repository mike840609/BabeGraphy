//
//  uploadVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/2.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Fusuma

class uploadVC: UIViewController , UITextViewDelegate ,FusumaDelegate{
    
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    
    @IBOutlet weak var publishBtn: MaterialButton!
    @IBOutlet weak var removeBtn: MaterialButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Upload"
        
        // disable publish btn
        publishBtn.enabled = false
        publishBtn.backgroundColor = .lightGrayColor()
        
        // hide remove button
        removeBtn.hidden = true
        
        // no image
        picImg.image = UIImage(named: "upload")
        
        // hide kyeboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.showFusuma))
        picTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
        
        
    }
    
    
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(image: UIImage) {
        
        // enable publish btn
        publishBtn.enabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // show removeBtn
        removeBtn.hidden = false
        
        print("Image selected")
        picImg.image = image
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        // enable publish btn
        publishBtn.enabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // show removeBtn
        removeBtn.hidden = false
        
        print("video completed and output to file: \(fileURL)")
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
    }
    
    // MARK : - TextView
    
    
    // MARK: - Customer function
    // hide kyeboard function
    
    func showFusuma(){
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    
    // MARK: - IBAction
    
    @IBAction func removeBtn_click(sender: AnyObject) {
        self.viewDidLoad()
    }
    
    @IBAction func publishBtn_click(sender: AnyObject) {
        self.view.endEditing(true)
        
    }
    
}
