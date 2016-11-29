//
//  multipleChoseVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/26.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//  製作相簿頁面

import UIKit

let PhotoBrowserCellIdentifier = "PhotoBrowserCell"


class multipleChoseVC: UICollectionViewController {
    
    var posts = [Post]()
    
    var selectedPhotos = [String]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        selectedPhotos.removeAll(keepCapacity: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "0/8"
        
        collectionView?.allowsMultipleSelection = true
        
    }
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    // Customer func - cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemWidth = (view.bounds.size.width - 5) / 3
        let size = CGSize(width: itemWidth, height: itemWidth)
        return size
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    // config cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        cell.imageView.image = nil
        cell.post = posts[indexPath.item]
        let imageURL = self.posts[indexPath.item].small_imgurl
        
        if let url = imageURL{
            cell.imageView.hnk_setImageFromURLAutoSize(NSURL(string: url)!)
        }
        
        
        
        
        return cell
    }
    
    
    // 選取照片
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoBrowserCollectionViewCell
        
        if cell.selected == true {
            
            cell.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.67, alpha: 0.8)
            cell.alpha = 0.3
            
            guard let url = cell.post?.imgurl else { return}
            
            selectedPhotos.append(url)
            
            print(selectedPhotos.count)
            
            
            // 照片數量達到模板樣式
            if selectedPhotos.count == templateItems {
                
                
                // 輸入 相簿名稱
                let  uuid = NSUUID().UUIDString
                print(uuid)
                
                
                //  版型判斷
                if templateItems == 8{
                    ApiService.shareInstance.pdf_create(uuid, baby_name: "mike_test", url1: self.selectedPhotos[0], url2: self.selectedPhotos[1], url3: self.selectedPhotos[2], url4: self.selectedPhotos[3], url5: self.selectedPhotos[4], url6: self.selectedPhotos[5], url7: self.selectedPhotos[6], url8: self.selectedPhotos[7], completion: { (json) in
//                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.navigationController?.popViewControllerAnimated(true)
                    })

                }else if templateItems == 5 {
                    ApiService.shareInstance.pdf_create2(uuid, baby_name: "mike_test", url1: self.selectedPhotos[0], url2: self.selectedPhotos[1], url3: self.selectedPhotos[2], url4: self.selectedPhotos[3], url5: self.selectedPhotos[4], completion: { (json) in

                        self.navigationController?.popViewControllerAnimated(true)
                    })

                    
                }
                
            }
            
            self.navigationController?.navigationItem.title = "\(selectedPhotos.count)/8"
            
        }
    }
    
    // 反選
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.alpha = 1
        
        // remove item in selected array
        for (index, element) in selectedPhotos.enumerate() where element == cell.post?.imgurl{
            selectedPhotos.removeAtIndex(index)
        }
    }
    
    
}
