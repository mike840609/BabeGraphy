//
//  FeedCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


var imageCache = NSCache()

// MARK: - CUSTOMER Cell
class FeedCell: UICollectionViewCell , NVActivityIndicatorViewable {
    
    var feedController: FeedController?
    
    func animate() {
        //feedController?.animateImageView(statusImg)
    }
    
    
    var post:Post?{
        didSet{
            
            // statusImg.image = nil
            loader.startAnimating()
            
            if let statusImageUrl = post?.imgurl{
                statusImg.hnk_setImageFromURLAutoSize(NSURL(string:statusImageUrl)!)
                loader.stopAnimating()
            }
            setupNameLocationStatusAndProfileImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // prepare function
    override func prepareForReuse() {
        statusImg.image = nil
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        return label
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    let statusTextView:UITextView = {
        let textView = UITextView()
        //        textView.text = "Today is a good day"
        textView.font = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = false
        return textView
    }()
    
    let statusImg:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.userInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel:UILabel = {
        let label = UILabel()
        label.text = "400 Likes  12 Comments"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 161)
        return label
    }()
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    // static func call use: Classname.method
    let likeButton:UIButton = FeedCell.buttonForTtitle("Like", imageName: "like")
    let commentButton:UIButton  = FeedCell.buttonForTtitle("Comment", imageName: "comment")
    let shareButton:UIButton  = FeedCell.buttonForTtitle("Share", imageName: "share")
    
    static func buttonForTtitle(title:String,imageName:String) -> UIButton{
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 143), forState: .Normal)
        
        button.setImage(UIImage(named: imageName), forState:.Normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        return button
    }
    
    // Set Cell Content
    func setupNameLocationStatusAndProfileImage(){
        
        // 解包 姓名 創建時間
        if let name = post?.author_name, let created_at = post?.created_at{
            
            let attributedText = NSMutableAttributedString(
                string: name,
                attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(14)])
            
            // 計算和現在的時間差
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let from =  dateFormatter.dateFromString( created_at )
            let now = NSDate()
            let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
            let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
            
            
            var time_after_cal:String = String()
            
            if difference.second <= 0 {
                time_after_cal = "  just now"
            }
            if difference.second > 0 && difference.minute == 0 {
                time_after_cal = "  \(difference.second) 秒前."
            }
            if difference.minute > 0 && difference.hour == 0 {
                time_after_cal = "  \(difference.minute) 分鐘前."
            }
            if difference.hour > 0 && difference.day == 0 {
                time_after_cal = "  \(difference.hour) 小時前."
            }
            if difference.day > 0 && difference.weekOfMonth == 0 {
                time_after_cal = "  \(difference.day) 天前."
            }
            if difference.weekOfMonth > 0 {
                time_after_cal = "  \(difference.weekOfMonth) 週前"
            }
            
            attributedText.appendAttributedString(NSAttributedString(
                string: time_after_cal,
                attributes:[NSFontAttributeName:UIFont.boldSystemFontOfSize(12),
                    NSForegroundColorAttributeName:UIColor.rgb(155, green: 161, blue: 175)]))
            
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            attributedText.addAttribute(NSParagraphStyleAttributeName,
                                        value: paragraphStyle,
                                        range: NSMakeRange(0,attributedText.string.characters.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRectMake(0, -2, 12, 12)
            attributedText.appendAttributedString(NSAttributedString(attachment: attachment))
            nameLabel.attributedText = attributedText
        }
        
        if let content = post?.content{
            statusTextView.text = content
        }
        
        if let author_imgurl = post?.author_imgurl{
            profileImageView.hnk_setImageFromURLAutoSize(NSURL(string: author_imgurl)!)
        }
        
        if let imgurl = post?.imgurl{
            statusImg.hnk_setImageFromURLAutoSize(NSURL(string: imgurl )!)
        }
        
        if let likes = post?.numLikes,let comments = post?.numComments{
            likesCommentsLabel.text = "\(likes) Likes  \(comments) Comments"
        }
    }
    
    
    func setupViews(){
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImg)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        
        // MARK: - Add Gesture
        // statusImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        shareButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareFunction)))
        likeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeFunction)))
        commentButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentFunction)))
        
        
        setupStatusImageViewLoader()
        
        // 用自定義方法 簡化autolayout
        addConstraintWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView,nameLabel)
        addConstraintWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintWithFormat("H:|[v0]|", views: statusImg)
        addConstraintWithFormat("H:|-12-[v0]|", views: likesCommentsLabel)
        addConstraintWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        // button constraints Button Equal another
        addConstraintWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: likeButton,commentButton,shareButton)
        addConstraintWithFormat("V:|-12-[v0]", views: nameLabel)
        
        
        addConstraintWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(300)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView,statusTextView,statusImg,likesCommentsLabel,dividerLineView,likeButton)
        addConstraintWithFormat("V:[v0(44)]|", views: commentButton)
        addConstraintWithFormat("V:[v0(44)]|", views: shareButton)
        
    }
    
    // MARK: - Button Function
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    func setupStatusImageViewLoader() {
        
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.blackColor()
        statusImg.addSubview(loader)
        statusImg.addConstraintWithFormat("H:|[v0]|", views: loader)
        statusImg.addConstraintWithFormat("V:|[v0]|", views: loader)
    }
    
    
    func likeFunction () {
        
        guard let post_id = post?._id else  {return}
        
        // 按讚
        // 進到閉包區間 表示成功傳回按讚資料 到server
        ApiService.shareInstance.press_like(post_id) { (json) in
            print(json)
        }
        
        /* 收回讚
         ApiService.shareInstance.cancel_like(post_id) { (json) in
         print(json)
         }
         */
    }
    
    
    
    func commentFunction () {
        print("commentFunction_ Pressed ")
    }
    
    
    func shareFunction() {
        
        let hokusai = Hokusai()
        // Add a button with a closure
        hokusai.addButton("Facebook") {
            print("facebook")
        }
        
        hokusai.addButton("Instagram") {
            print("Instagram")
        }
        
        hokusai.addButton("Twitter") {
            print("Twitter")
        }
        
        
        // hokusai.addButton("Button 2", target: self, selector: Selector("button2Pressed"))
        hokusai.fontName = "Verdana-Bold"
        hokusai.colorScheme = HOKColorScheme.Tsubaki
        
        // Change a title for cancel button. Default is Cancel. (Optional)
        hokusai.cancelButtonTitle = "Done"
        
        // Add a callback for cancel button (Optional)
        hokusai.cancelButtonAction = {
            print("canceled")
        }
        
        // Show Hokusai
        hokusai.show()
    }
    
}

