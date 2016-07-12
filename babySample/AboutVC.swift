//
//  AboutVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/13.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SafariServices


class AboutVC: UITableViewController {
    
    var sectionTitles = ["Leave Feedback", "Follow Us"]
    var sectionContent = [["Rate us on App Store", "Tell us your feedback"],["Twitter", "Facebook", "Pinterest"]]
    var links = [ "https://github.com/Cassiszuoan/laravel-restapi", "https://github.com/mike840609/BabeGraphy","https://www.google.com.tw/"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 移除第二個區塊的空白列
        tableView.tableFooterView = UIView(frame: CGRectZero)

    }

    // MARK: - Table view data source

    // Section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // Row
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 2
        }else{
            return 3
        }
    }

    // title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     
        return sectionTitles[section]
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        
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
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
}
