//
//  album_searchVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class album_searchVC: UITableViewController {
    
    var albums :[Album] = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        albums.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        getAlbums()
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        getAlbums()
    }


    
    func getAlbums () {
        ApiService.shareInstance.pdf_search { (json) in
            
            for (_ ,subJson):(String, SwiftyJSON.JSON) in json {
                
                print(subJson)
                
                let album = Album()
                
                album._id = subJson["_id"].string
            
                album.author_id = subJson["author_id"].string
                album.pdf_url = subJson["pdf_url"].string
                album.author_name = subJson["author_name"].string
                
                album.created_at = subJson["created_at"].string
                album.updated_at = subJson["updated_at"].string
                
                self.albums.append(album)
               
            }
            self.tableView.reloadData()
        }
        

        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return albums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! albumCell
        let album = albums[indexPath.row]
        
        cell.album = album
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let url = albums[indexPath.item].pdf_url else { return}
        
        let safariController = SFSafariViewController(URL:NSURL(string: url)!, entersReaderIfAvailable: true)
        
        presentViewController(safariController, animated: true, completion: nil)
        
    }



}
