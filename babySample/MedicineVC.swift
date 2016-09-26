//
//  MedicineVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON

class MedicineVC: UITableViewController {
    
    var medicines :[Medicine] = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMedicines()

    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! medicineCell
        
        cell.medicine = medicines[indexPath.item]
        
        
        return cell
        
        
        
    }
    
    func getMedicines () {
        
        /*
         vaccine_chi: "Ｂ型肝炎疫苗",
         vaccine_eng: "HepB",
         time: "出生24小時內、出生滿1個月及出生滿6個月",
         number: "共3劑"
         */
        
        medicines.removeAll(keepCapacity: false)
        
        
        ApiService.shareInstance.getMedicine { (json) in
            
            
            
            for (_ ,subJson):(String, SwiftyJSON.JSON) in json {
                
                let medicine = Medicine()
            
                medicine.number = subJson["number"].string
                medicine.time = subJson["time"].string
                medicine.vaccine_eng = subJson["vaccine_eng"].string
                medicine.vaccine_chi = subJson["vaccine_chi"].string
                
                if  medicine.vaccine_chi?.characters.count <= 3{
                    continue
                }else{
                    self.medicines.append(medicine)
                }
                
                
            }
            
            self.tableView.reloadData()
        }

    }



}


