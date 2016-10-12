//
//  GenVCViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/10/13.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class GenVC: UIViewController {
    
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var qrcodeImage: CIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey(USER_ID) {
            
            let data = id.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            
            displayQRCodeImage()
            
        }
        
    }
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        imgQRCode.transform = CGAffineTransformMakeScale(CGFloat(slider.value), CGFloat(slider.value))
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Custom method implementation
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)
    }

    
    
}
