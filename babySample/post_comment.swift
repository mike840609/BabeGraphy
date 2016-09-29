//
//  post_comment.swift
//
//
//  Created by 蔡鈞 on 2016/9/21.
//
//

import UIKit


//  For Calculate the view which over on headerView
private let kTableHeaderHeight: CGFloat = 400.0
private let kTableHeaderCutAway: CGFloat = 60.0


class post_comment: UIViewController ,UITableViewDataSource,UITableViewDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postImg:UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    
    var post:Post?
    
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
        
        self.navigationController?.navigationBarHidden = true
        navigationController?.hidesBarsOnSwipe = true
        self.tabBarController?.tabBar.hidden = true
        
        
        updateHeaderView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tableView.delegate = self
        //        tableView.dataSource = self
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        
        headerView.layer.mask = headerMaskLayer
        
        self.updateHeaderView()
        setupView()
        
        addobserver()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.navigationController?.navigationBarHidden = false
        
        self.tabBarController?.tabBar.hidden = false
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
        
        
        // 鍵盤隱藏
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
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
    
    func addobserver(){
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWasShown),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillHide),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        commentTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        commentTextField = nil
    }
    
    
    // 點擊隱藏鍵盤
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomAnchor.constant = keyboardFrame.size.height + 20
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomAnchor.constant = 0
        })
        
    }
    
    // MARK: - Navigationbar Delegate
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = post?.comment_Users.count else { return 0 }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ItemCell
        
        cell.newsItem = item
        
        cell.comments = post?.comment_Users[indexPath.item]
        

        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //        let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
        //            print("more button tapped")
        //        }
        //        more.backgroundColor = UIColor(red:0.81, green:0.85, blue:0.87, alpha:1.00)
        
        _ = post?.comment_Users[indexPath.item]
        
        let Delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("Delete button tapped")
        }
        
        Delete.backgroundColor = UIColor(red:0.933, green:0.191, blue:0.469, alpha:0.53)
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor(red:0.10, green:0.81, blue:0.97, alpha:1.00)
        
        return [Delete ,share ]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    @IBAction func commentBtn_tapped(sender: AnyObject) {
        
        guard let post_id = post?._id else {return}
        
        guard let content = commentTextField.text else {return}
        
        
        // 從本地端直接載入當前留言資料 =========================================
        let comment = Comment()
        if let user = user{
            comment.user_name = user["data"][0][JSON_NAME].string
            comment.content = content
            comment.user_avatar = user["data"][0]["avatar"].string
            comment.user_id = user["data"][0][JSON_ID].string
        }
        
        self.post?.comment_Users.append(comment)
        self.commentTextField.text = nil
        self.view.endEditing(true)
        self.tableView.reloadData()
        
        
        
        // post to server =========================================
        ApiService.shareInstance.comment_post(post_id, content: content) { (json) in
                        print(json)
        }
        
    }
    
    
    
}
