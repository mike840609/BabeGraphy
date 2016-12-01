//
//  Baby_Fascicle.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class Baby_Fascicle: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    var albums :[Album] = []
    
    var fakeImage :[String] = [
        "http://www.bayuche.com/uploads/files/image/image/200907071143181890.jpg",
        "http://i.telegraph.co.uk/multimedia/archive/02464/baby_2464393b.jpg",
        "http://www.thebabyshows.com/images/baby-landing.png",
        "http://media.irishcentral.com/images/MI+Baby+brown+hair+blue+eyes+Irish+baby+names+iStock.jpg",
        "http://gb.cri.cn/mmsource/images/2010/11/01/21/1770902844571060725.jpg",
        "http://gd3.alicdn.com/bao/uploaded/i3/TB1cH8QIVXXXXXUaXXXXXXXXXXX_!!0-item_pic.jpg_400x400.jpg"
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Album"
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the height for 3.5-inch screen
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
        
        getAlbums()
        
    }
    
    private struct Storyboard{
        static let CellIdentifier = "Cell"
    }
    
    // collectionview datasource && delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return   1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        
        cell.interestTitleLabel.text = albums[indexPath.item].album_name
        
        cell.featuredImageView.hnk_setImageFromURL(NSURL(string:fakeImage[indexPath.item%6])!)
        
        cell.layer.cornerRadius = 4.0
        
        return cell
        
    }
    
    
    
    // MARK: - Customer function
    
    func getAlbums () {
        ApiService.shareInstance.pdf_search { (json) in
            
            self.albums.removeAll(keepCapacity: false)
            
            for (_ ,subJson):(String, SwiftyJSON.JSON) in json {
                
                print(subJson)
                
                let album = Album()
                
                album._id = subJson["_id"].string
                album.author_id = subJson["author_id"].string
                album.pdf_url = subJson["pdf_url"].string
                album.author_name = subJson["author_name"].string
                album.album_name = subJson["album_name"].string
                album.created_at = subJson["created_at"].string
                album.updated_at = subJson["updated_at"].string
                
                self.albums.append(album)
                
            }
            self.collectionView.reloadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        if let url =  albums[indexPath.item].pdf_url{
            
            let url = NSURL(string: url)
            
            print(url)
            
            let safariController = SFSafariViewController(URL:url!, entersReaderIfAvailable: true)
            
            
            
            presentViewController(safariController, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    @IBAction func CreateBook(sender: AnyObject) {
        
    }
    
    
    @IBAction func SearchBook(sender: AnyObject) {
        
        let albumSearchVC = self.storyboard?.instantiateViewControllerWithIdentifier("album_searchVC") as! album_searchVC
        
        self.navigationController?.pushViewController(albumSearchVC, animated: true)
        
        
    }
    
    
    @IBAction func dismissVC(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }
}


