//
//  AlbumVCViewController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/11.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class AlbumVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton:UIButton!
    @IBOutlet weak var currentUserFullNameButton:UIButton!
    
    // MenuBar
    @IBOutlet weak var leftBarButton: UIButton!
    private lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    
    // MARK: - UICollectionViewDataSource
    private var interests = Interest.createInterests()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private struct Storyboard{
        static let CellIdentifier = "Cell"
    }
    
    @IBAction func showMenuAction(sender: UIButton) {
        
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("MenuViewController")
        menuVC.modalPresentationStyle = .Custom
        menuVC.transitioningDelegate = self
        if menuVC is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        }
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = sender
        presentationAnimator.duration = 0.4
        self.presentViewController(menuVC, animated: true, completion: nil)
        
    }
    
}

extension AlbumVC:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return interests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        // 類別內設值屬性 自動賦值
        cell.interest = self.interests[indexPath.item]
        
        return cell
    }
}

// 自動置中
extension AlbumVC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.memory
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        
        targetContentOffset.memory = offset
        
    }
    
    
}


// MARK : - MenuDelegate
extension AlbumVC: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Presentation
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Dismissal
        return presentationAnimator
    }
}