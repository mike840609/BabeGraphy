//
//  NewViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/28.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import CoreData

class NewViewController: UITableViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doSave(sender: AnyObject) {
        print("do save \(nameTextField.text)")
        
        // 講解 guard let 使用語法 與 if let 差別
        guard let todoName = nameTextField.text where !todoName.isEmpty else {
            
            // Alert
            // 建立 UIAlertController
            let alert = UIAlertController(title: "提醒", message: "請輸入資料！", preferredStyle: .Alert)
            
            // 增加 Action
            let ok = UIAlertAction(title: "OK", style: .Default , handler:nil)
            
            // 把 Action 加到 UIAlertController
            alert.addAction(ok)
            
            // 顯示 Alert
            self.presentViewController(alert, animated: true, completion: nil);
            
            return
        }
        
        // 取得 Context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        // 建立 Entity
        let todoItem = NSEntityDescription.insertNewObjectForEntityForName("TodoItem", inManagedObjectContext: context) as! TodoItem
        
        todoItem.name = todoName
        
        // 儲存 Todo項目
        appDelegate.saveContext()
        
        navigationController?.popViewControllerAnimated(true)
    }

}
