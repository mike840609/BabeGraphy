//
//  EditVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/10.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import PMAlertController


class EditVC: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var repeatPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var fullnameTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bioTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var webTxt: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var FbBtn: UIButton!
    @IBOutlet weak var IgBtn: UIButton!
    
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    
    // MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        loadUserInfo()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTextTheme()
        
        
        // 手勢添加
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(EditVC.loadImg))
        avaTap.numberOfTapsRequired = 1
        avaImg.userInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        // image radious
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
        // 鍵盤隱藏
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }
    
    // MARK: - Customer function
    
    func loadUserInfo() {
        if let fullname = user!["data"][0][JSON_NAME].string{
            fullnameTxt.text = fullname
        }
        
        if let bio = user!["data"][0][JSON_BIO].string{
            bioTxt.text = bio
        }
        
        if let web = user!["data"][0][JSON_WEB].string{
            webTxt.text = web
        }
        
        // 若是有設定新照片 user!["data"][0]["avatar"] 會被設定成 nil  在這裡會解包失敗
        if let avaUrl = user!["data"][0]["avatar"].string{
            avaImg.hnk_setImageFromURL(NSURL(string: avaUrl)!)
        }
        
    }
    // 個人資料修改
    func userUpdate (){
        
        //http://140.136.155.143/api/user/update
        //parameter : token , password, name, about(optional) , website(optional)
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{ return }
        
        // Nil Coalescing Operator
        let name =  fullnameTxt?.text ?? ""
        let bio = bioTxt?.text ?? ""
        let web = webTxt?.text ?? ""
        
        let parameters = ["token":AccessToken, "name": name , "about":bio , "website": web]
        
         Alamofire.request(.POST, "http://140.136.155.143/api/user/update",parameters: parameters).validate().response { request, response, data, error in
            
            if error == nil{
                
                print("修改成功")
                
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            }
        }
    }
    
    
    // 點擊隱藏鍵盤
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // MARK: - Image Picker
    func loadImg(){
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.sourceType = .PhotoLibrary
        
        picker.allowsEditing = true
        
        picker.navigationBar.tintColor = UIColor.whiteColor()
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // connect selected image to our imageView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 把舊的照片值清掉 避免重複讀取 無法設定照片
        user!["data"][0]["avatar"] = nil
        
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    // MARK: - Styling the text fields to the Skyscanner theme
    func setTextTheme(){
        
        cancelBtn.tintColor = UIColor.whiteColor()
        saveBtn.tintColor = UIColor.whiteColor()
        
        self.FbBtn.layer.borderColor = lightGreyColor.CGColor
        self.FbBtn.layer.borderWidth = 1
        self.FbBtn.setTitleColor(overcastBlueColor, forState: .Highlighted)
        
        self.IgBtn.layer.borderColor = lightGreyColor.CGColor
        self.IgBtn.layer.borderWidth = 1
        self.IgBtn.setTitleColor(overcastBlueColor, forState: .Highlighted)
        
        
        self.applySkyscannerThemeWithIcon(self.passwordTxt)
        self.passwordTxt.iconText = "\u{f084}"
        self.passwordTxt.placeholder = "Password"
        self.passwordTxt.selectedTitle = "enter your Password"
        self.passwordTxt.title = "Password"
        
        self.applySkyscannerThemeWithIcon(self.repeatPassword)
        self.repeatPassword.iconText = "\u{f046}"
        self.repeatPassword.placeholder = "Repeat password"
        self.repeatPassword.selectedTitle = "enter your Password"
        self.repeatPassword.title = "confirm password"
        
        self.applySkyscannerThemeWithIcon(self.fullnameTxt)
        self.fullnameTxt.iconText = "\u{f044}"
        self.fullnameTxt.placeholder = "username"
        self.fullnameTxt.selectedTitle = "Your fullname"
        self.fullnameTxt.title = "username"
        
        self.applySkyscannerThemeWithIcon(self.bioTxt)
        self.bioTxt.iconText = "\u{f040}"
        self.bioTxt.placeholder = "About you"
        self.bioTxt.selectedTitle = "describe your self"
        self.bioTxt.title = "About"
        
        self.applySkyscannerThemeWithIcon(self.webTxt)
        self.webTxt.iconText = "\u{f230}"
        self.webTxt.placeholder = "website"
        self.webTxt.selectedTitle = "Your website or IG , Facebook"
        self.webTxt.title = "website"
        
        
        self.passwordTxt.delegate = self
        self.repeatPassword.delegate = self
        self.fullnameTxt.delegate = self
        self.bioTxt.delegate = self
        self.webTxt.delegate = self
        
    }
    
    func applySkyscannerThemeWithIcon(textField: SkyFloatingLabelTextFieldWithIcon) {
        self.applySkyscannerTheme(textField)
        textField.iconColor = lightGreyColor
        textField.selectedIconColor = overcastBlueColor
        textField.iconFont = UIFont(name: "FontAwesome", size: 15)
    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        
        textField.tintColor = overcastBlueColor
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        textField.placeholderFont = UIFont(name: "AppleSDGothicNeo-Light", size: 18)
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
    }
    
    // MARK: - Btn_Click
    var isSignUpBtnPressed = false
    var showingTitleInProgress = false

    func showingTitleInAnimationComplete() {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        let displayTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(displayTime, dispatch_get_main_queue(), {
            self.showingTitleInProgress = false
            if(!self.isSignUpBtnPressed) {
                self.hideTitleVisibleFromFields()
            }
        })
    }
    
    func hideTitleVisibleFromFields() {
        
        self.passwordTxt.setTitleVisible(false, animated: true)
        self.repeatPassword.setTitleVisible(false, animated: true)
        self.fullnameTxt.setTitleVisible(false, animated: true)
        self.bioTxt.setTitleVisible(false, animated: true)
        self.webTxt.setTitleVisible(false, animated: true)
        
        
        self.passwordTxt.highlighted = false
        self.repeatPassword.highlighted = false
        self.fullnameTxt.highlighted = false
        self.bioTxt.highlighted = false
        self.webTxt.highlighted = false
    }
    
    // MARK: - Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        

        
        if (textField == self.passwordTxt){
            self.validatePasswordTextField(textField.text)
        }
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder! {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        

        if (textField == self.passwordTxt){
            
            var txtAfterUpdate:NSString = passwordTxt.text! as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            
            self.validatePasswordTextField(txtAfterUpdate as String)
        }
        
        
        if (textField == self.repeatPassword){
            
            var txtAfterUpdate:NSString = repeatPassword.text! as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            
            
            self.validateRepeatPasswordTextField(txtAfterUpdate as String)
            
        }
        
        return true
    }

    
    
    // MARK: - Check function
    func  validatePasswordTextField(password: String?){
        
        if let password = password {
            
            if(password.characters.count == 0) {
                
                self.passwordTxt.errorMessage = nil
                
            }else if password.characters.count>0 && password.characters.count<8{
                
                self.passwordTxt.errorMessage = NSLocalizedString("Password should be at least 8 characters", tableName: "SkyFloatingLabelTextField", comment: " ")
            }else{
                
                self.passwordTxt.errorMessage = nil
            }
            
        }else {
            self.passwordTxt.errorMessage = nil
        }
        
    }

    
    
    func  validateRepeatPasswordTextField(repeat_password: String?){
        
        
        if let repeat_password = repeat_password {
            
            if (!isSamePassword(repeat_password)){
                self.repeatPassword.errorMessage = NSLocalizedString("Password should be the same", tableName: "SkyFloatingLabelTextField", comment: " ")
            }else{
                self.repeatPassword.errorMessage = nil
            }
        }else {
            self.repeatPassword.errorMessage = nil
        }
        
    }
    
    
    func  isSamePassword(repeat_password:String?) -> Bool {
        
        if let password = passwordTxt.text{
            
            return repeat_password == password
            
        }else {
            return false
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    @IBAction func saveBtn_click(sender: AnyObject) {
        
        guard let imageTemp = avaImg.image else {return}
        
        // parse  profile image
        ApiService.shareInstance.avaImgupload(imageTemp)
        
        // parse user info
        userUpdate()
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    @IBAction func ConnectFB_click(sender: AnyObject) {
        
    }
    
    @IBAction func ConnectIG_click(sender: AnyObject) {
        
    }

    
    
    
}
