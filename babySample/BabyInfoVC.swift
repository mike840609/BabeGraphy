//
//  BabyInfoVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/22.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON

class BabyInfoVC: UITableViewController {
    
    @IBOutlet weak var dimissBtn: UIButton!
    
    
    var babys:[Baby] = [Baby]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimissBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        dimissBtn.setTitle(String.fontAwesomeIconWithCode("fa-chevron-down"), forState: .Normal)
        
        
        getBaby ()
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func getBaby () {
        
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else { return}
        
        
        
        ApiService.shareInstance.baby_serach(AccessToken) { (json) in
            
            
            // json 轉換已在  baby 類別做好
            
            for (_ ,subJson):(String, SwiftyJSON.JSON) in json {
                
                let baby = Baby()
                baby.baby_name = subJson["baby_name"].string
                baby.baby_blood = subJson["baby_blood"].string
                baby.baby_birth = subJson["baby_birth"].string
                baby.imgurl = subJson["imgurl"].string
                baby.small_imgurl = subJson["small_imgurl"].string
                
                
                baby.created_at = subJson["created_at"].string
                baby.parent_name = subJson["parent_name"].string
                baby.parent_id = subJson["parent_id"].string
                baby.updated_at = subJson["updated_at"].string
                baby._id = subJson["_id"].string
                
                self.babys.append(baby)
            }
            
            
            self.tableView.reloadData()
            
            print(json)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return babys.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! infoCell
        
        cell.baby = babys[indexPath.item]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        cell.alpha = 0
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -250, 10, 0)
        
        // let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 500, 0)
        
        cell.layer.transform = rotationTransform
        
        UIView.animateWithDuration(0.5) {
            
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        

        let Delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            if let id = self.babys[indexPath.item]._id {
                
                ApiService.shareInstance.baby_delete(id, completion: { (json) in
                    
                    print(json)
                    
                    self.babys.removeAtIndex(index.item)
                    
                self.tableView.reloadData()

                })
            }

        }
        
        Delete.backgroundColor = UIColor(red:0.933, green:0.191, blue:0.469, alpha:0.53)
        
        return [Delete ]
        
    }
    

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

}
