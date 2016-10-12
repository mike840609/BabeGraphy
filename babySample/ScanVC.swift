//
//  ViewController.swift
//  QRReaderDemo
//
//  Created by Simon Ng on 23/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON


protocol goGuestDelegate:class {
    
    func goGuestVC(id:String)
    
}

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    @IBOutlet weak var messageLabel:UILabel!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            captureSession?.startRunning()
            
            
            view.bringSubviewToFront(messageLabel)
            
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            
            print(error)
            
            return
        }
        
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        
        let  metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        if supportedBarCodes.contains(metadataObj.type) {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            // segue to guestVC
            if metadataObj.stringValue != nil  {
                
                messageLabel.text = metadataObj.stringValue
                
                showGuest(metadataObj.stringValue)
                
            }
            
        }
        
        
    }
    
    
    
    func showGuest(id:String) {
        
        
        
        let user_data:[String: AnyObject] = [
            "user_id" : id,
            "profile_picture" : "",
            "username" : ""
        ]
        
        let user_json = SwiftyJSON.JSON(user_data)
        guestJSON.append(user_json)
        
        let destination = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
        
        
         let navigationController2 = UINavigationController(rootViewController: destination)
        
        // navigationController2.navigationItem.rightBarButtonItem?.title = "Cancel"
        // navigationController2.navigationItem.rightBarButtonItem?.action = #selector(dismiss)
        
        presentViewController(navigationController2, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

