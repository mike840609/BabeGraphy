//
//  PostVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/8/29.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

// 文章內頁

/*  ===================instance storyboard===========================
 
 let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
 self.navigationController?.pushViewController(followers, animated: true)
 
 ========================================================== */

import UIKit

//  For Calculate the view which over on headerView
private let kTableHeaderHeight: CGFloat = 400.0
private let kTableHeaderCutAway: CGFloat = 60.0


class PostVC: UITableViewController {
    
    // Baby Image
    @IBOutlet weak var postImg:UIImageView!
    
    // post object
    var post:Post?
    
    //    var post:Post?{
    //        didSet{
    //
    //            // statusImg.image = nil
    //            loader.startAnimating()
    //
    //            if let statusImageUrl = post?.imgurl{
    //                statusImg.hnk_setImageFromURLAutoSize(NSURL(string:statusImageUrl)!)
    //                loader.stopAnimating()
    //            }
    //
    //
    //            guard let UserID:String? = NSUserDefaults.standardUserDefaults().stringForKey(USER_ID) else {return}
    //
    //            // 走訪陣列 判斷 說過讚的陣列中有沒有使用者ID
    //            for i in (post?.likes_Users)!{
    //
    //                if i.user_id == UserID{
    //                    print("說過讚")
    //                    let tintedImage = UIImage(named: "like")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
    //
    //                    likeButton.setImage(tintedImage, forState:.Normal)
    //
    //                    // 載入cell 前先判斷是否按過讚
    //                    // likeButton.tintColor = UIColor(red: 0.00, green: 0.58, blue: 1.00, alpha: 1.00)
    //                    // likeButton.tintColor = UIColor(red:0.478, green:0.878, blue:0.944, alpha:0.53)
    //                    likeButton.tintColor = UIColor(red:1.00, green:0.55, blue:0.70, alpha:1.00)
    //                    isLiked = true
    //                }
    //
    //            }
    //            setupNameLocationStatusAndProfileImage()
    //        }
    //    }
    //
    
    // Cover View
    var headerView: UIView!
    
    var headerMaskLayer: CAShapeLayer!
    
    let items = [
        NewsItem(category: .World, summary: "Climate change protests, divestments meet fossil fuels realities"),
        NewsItem(category: .Europe, summary: "Scotland's 'Yes' leader says independence vote is 'once in a lifetime'"),
        NewsItem(category: .MiddleEast, summary: "Airstrikes boost Islamic State, FBI director warns more hostages possible"),
        NewsItem(category: .Africa, summary: "Nigeria says 70 dead in building collapse; questions S. Africa victim claim"),
        NewsItem(category: .AsiaPacific, summary: "Despite UN ruling, Japan seeks backing for whale hunting"),
        NewsItem(category: .Americas, summary: "Officials: FBI is tracking 100 Americans who fought alongside IS in Syria"),
        NewsItem(category: .World, summary: "South Africa in $40 billion deal for Russian nuclear reactors"),
        NewsItem(category: .Europe, summary: "'One million babies' created by EU student exchanges"),
        ]
    
    
    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateHeaderView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        
        headerView.layer.mask = headerMaskLayer
        updateHeaderView()
        
        setupView()
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            [self]
            self.updateHeaderView()
            self.tableView.reloadData()
            }, completion: { (context) -> Void in
        })
    }
    
    func setupView() {
        if let post = self.post{
            
            guard let url = post.imgurl else {return}
            postImg.hnk_setImageFromURL(NSURL(string: url)!)
            
        }
    }
    
    // MARK: - Customer Function Delegate
    func updateHeaderView() {
        
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
    }
    
    // MARK: - Navigationbar Delegate
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = post?.comment_Users.count else { return 0 }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ItemCell
        
        cell.newsItem = item
        
        cell.comments = post?.comment_Users[indexPath.item]
        
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
}
