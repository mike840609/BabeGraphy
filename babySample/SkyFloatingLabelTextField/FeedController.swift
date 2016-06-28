//
//  testCollectionViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//
import Foundation
import UIKit

private let reuseIdentifier = "Cell"
let posts = Posts()

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Mark: - CollectionView Set
        navigationItem.title = "BabeGraphy"
        
        collectionView!.alwaysBounceVertical = true
        
        collectionView!.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.collectionView!.registerClass(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    // release memory
    override func didReceiveMemoryWarning() {
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath]
        
        return feedCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = posts[indexPath].statusText{
            
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSizeMake(view.frame.width, rect.height + knownHeight + 16)
        }
        
        return CGSizeMake(view.frame.width, 500)
    }
    
    // Rotation autolayout
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
}
