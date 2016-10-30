//
//  AboutVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/13.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SafariServices
import PMAlertController

class AboutVC: UITableViewController {
    
    var sectionTitles = ["Leave Feedback", "Follow Us","QR Code" ,"Security"]
    var sectionContent = [["Rate us on App Store", "Tell us your feedback"],["Twitter", "Facebook", "Pinterest"],["Scan QR-Code","My QR-Code"],["Touch ID (指紋識別)"]]
    var links = [ "https://github.com/Cassiszuoan/laravel-restapi", "https://github.com/mike840609/BabeGraphy","https://www.google.com.tw/"]
    
    
    let defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 移除第二個區塊的空白列
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    // MARK: - Table view data source
    
    // Section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    // Row
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 2
        }else if section == 1{
            return 3
        }else if section == 2{
            return 2
        }else{
            return 1
        }
    }
    
    // title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        
        
        
        // 指紋識別
        if (indexPath.section == 3 ){
            if (indexPath.row == 0 ){
                
                let enabledSwitch = UISwitch(frame: CGRectZero) as UISwitch
                cell.accessoryView = enabledSwitch
                
                // 變更同步按鈕設定 第一次跟用戶要權限
                if (defaults.objectForKey(TouchID) != nil) {
                    
                    enabledSwitch.on = defaults.boolForKey(TouchID)
                    enabledSwitch.addTarget(self, action: #selector (onClickMySwicth), forControlEvents: UIControlEvents.ValueChanged)
                    
                }else{ // first time
                    
                    enabledSwitch.on = false
                    defaults.setBool(false, forKey: TouchID)
                }
                
            }
        }
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section{
            
        //Leave Feedback
        case 0:
            if indexPath.row == 0{
                if let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/"){
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            else if indexPath.row == 1{
                
                //tell us your feedback
                
                let safariController = SFSafariViewController(URL:NSURL(string: "https://www.google.com.tw/")!, entersReaderIfAvailable: true)
                
                presentViewController(safariController, animated: true, completion: nil)
                
            }
        // Follow Us
        case 1:
            if let url = NSURL(string:links[indexPath.row]){
                
                let safariController = SFSafariViewController(URL:url, entersReaderIfAvailable: true)
                presentViewController(safariController, animated: true, completion: nil)
            }
        // QR Code
        case 2:
            if indexPath.row == 0{
                
                let scannerVC = self.storyboard?.instantiateViewControllerWithIdentifier("ScanVC") as! ScanVC
                
                let navigationController = UINavigationController(rootViewController: scannerVC)
                
                self.presentViewController(navigationController, animated: true, completion: nil)
                
                
            }else if indexPath.row == 1{
                
                
                let genVC  = self.storyboard?.instantiateViewControllerWithIdentifier("GenVC") as! GenVC
                
                let navigationController = UINavigationController(rootViewController: genVC)
                
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        case 3:
            if  indexPath.row == 0{
                print ("touch id")
                
            }
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    // TOUCH ID : 繼聰要求 安全性
    
    
    internal func onClickMySwicth(sender: UISwitch){
        
        if sender.on {
            
            // 設定default data
            defaults.setBool(true, forKey: TouchID)
            
            
            
            let alertVC = PMAlertController(title: "已為您開啟指紋識別", description: "注意:若非本人無法開啟", image: UIImage(named: "fingerprint.png"), style: .Alert)
            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: {
                
            }))
            self.presentViewController(alertVC, animated: true, completion: nil)
            
            
            
        }
        else {
            defaults.setBool(false, forKey: TouchID)
            
        }
    }
    
}
