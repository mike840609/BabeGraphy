//
//  userVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/18.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke


class userVC: UITableViewController, UISearchBarDelegate  {
    
    var users: Array<SwiftyJSON.JSON> = []
    
    var searchBar = UISearchBar()
    
    var usernameArray = [String]()
    
    
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackgroundColor()
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        // call functions
        loadUsers()
        
        // call collectionView
        collectionViewLaunch()
    }
    
    // MARK: - Customer Function
    func loadUsers() {
        //
        //        Alamofire.request(.POST, "http://140.136.155.143/api/user/search",parameters: ["email":])
        
        
    }
    
    func collectionViewLaunch() {
        
        
    }
    
    
    // MARK: - SearchBar
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        Alamofire.request(.POST, "http://140.136.155.143/api/user/search",parameters: ["email":searchBar.text!]).responseJSON { (json) in
            
            switch json.result{
                
            case .Success(let json):
                
                let user = SwiftyJSON.JSON(json)
                
                self.users.append(user)
                
                print(json)
                
                self.tableView.reloadData()
                
            case .Failure(let error):
                
                print(error)
            }
            
            
        }
        
        // clean up
        self.usernameArray.removeAll(keepCapacity: false)
        self.users.removeAll(keepCapacity: false)
        
        return true
    }
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        // hide collectionView when started search
//        collectionView.hidden = true
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
    
    // clicked cancel button
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // unhide collectionView when tapped cancel button
//        collectionView.hidden = false
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        loadUsers()
    }
    
    
    
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    // cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        // hide follow button
        cell.followBtn.hidden = true
        
        cell.usernameLbl.text = users[indexPath.item]["data"][0]["name"].string
        
        cell.avaImg.hnk_setImageFromURL(NSURL(string: "http://www.sitesnobrasil.com/imagens-fotos/mulheres/l/lisa-simpson.png")!)
        
        return cell
    }
    
    // selected tableView cell - selected user
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        // calling cell again to call cell data
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
//        
//        // if user tapped on his name go home, else go guest
//        if cell.usernameLbl.text! == PFUser.currentUser()?.username {
//            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
//            self.navigationController?.pushViewController(home, animated: true)
//        } else {
//            guestname.append(cell.usernameLbl.text!)
//            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
//            self.navigationController?.pushViewController(guest, animated: true)
//        }
        
    }
    
    // MARK : Collection View
    
    
    
}
