//
//  FeedCell.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/12.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

var imageCache = NSCache()

// MARK: - CUSTOMER Cell
class FeedCell: UICollectionViewCell {
    
    var post:Post?{
        didSet{
            
            statusImg.image = nil
            loader.startAnimating()
            
            if let statusImageUrl = post?.statusImgUrl{
                
                // Cache check
                if let image = imageCache.objectForKey(statusImageUrl) as? UIImage{
                    statusImg.image = image
                    loader.stopAnimating()
                }else{
                    NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: statusImageUrl)!,completionHandler: {
                        (data,response,error) -> Void in
                        if error != nil{
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        imageCache.setObject(image!, forKey: statusImageUrl)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.statusImg.image = image
                            self.loader.stopAnimating()
                        })
                    }).resume()
                    
                }
                
                
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
        textView.text = "Today is a good day"
        textView.font = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = false
        return textView
    }()
    
    let statusImg:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
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
        
        if let name = post?.name{
            
            let attributedText = NSMutableAttributedString(
                string: name,
                attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(14)])
            
            attributedText.appendAttributedString(NSAttributedString(
                string: "\n15分鐘 台北市 ",
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
        
        if let statusText = post?.statusText{
            statusTextView.text = statusText
        }
        
        if let profileImagename = post?.profileImageName{
            profileImageView.image = UIImage(named:profileImagename)
        }
        
        if let statusImageName = post?.statusImageName{
            statusImg.image = UIImage(named: statusImageName)
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
        addConstraintWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView,statusTextView,statusImg,likesCommentsLabel,dividerLineView,likeButton)
        addConstraintWithFormat("V:[v0(44)]|", views: commentButton)
        addConstraintWithFormat("V:[v0(44)]|", views: shareButton)
        
    }
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.blackColor()
        statusImg.addSubview(loader)
        statusImg.addConstraintWithFormat("H:|[v0]|", views: loader)
        statusImg.addConstraintWithFormat("V:|[v0]|", views: loader)
    }
    
}

