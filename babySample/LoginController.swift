//
//  LoginController.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/9.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//
// test branch

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import PMAlertController
import FBSDKCoreKit
import FBSDKLoginKit


class LoginController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable{
    
    @IBOutlet weak var idText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var pwdText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginFbBtn: UIButton!
    
    
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    //    let overcastBlueColor = UIColor(red: 241, green: 169/255, blue: 160/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set theme
        self.setTextTheme()
        //self.idText.becomeFirstResponder()
        
        // recognizer
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(LoginController.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // 有fb_token 直接去抓資料
        if let _ = FBSDKAccessToken.currentAccessToken() {
            getFBUserData()
        }

    }
    
    func setTextTheme(){
        
        self.loginBtn.layer.borderColor = lightGreyColor.CGColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.setTitleColor(overcastBlueColor, forState: .Highlighted)
        
        self.loginFbBtn.layer.borderColor = lightGreyColor.CGColor
        self.loginFbBtn.layer.borderWidth = 1
        self.loginFbBtn.setTitleColor(overcastBlueColor, forState: .Highlighted)
        
        self.applySkyscannerThemeWithIcon(self.idText)
        self.idText.iconText = "\u{f007}"
        self.idText.placeholder = "Email"
        self.idText.selectedTitle = "your email address"
        self.idText.title = "Email"
        
        self.applySkyscannerThemeWithIcon(self.pwdText)
        self.pwdText.iconText = "\u{f084}"
        self.pwdText.placeholder = "Password"
        self.pwdText.selectedTitle = "your Password"
        self.pwdText.title = "Password"
        self.idText.delegate = self
        self.pwdText.delegate = self
        
    }
    
    // 點擊隱藏鍵盤
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // MARK: - Styling the text fields to the Skyscanner theme
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
    
    // MARK: - loginBtn pressed 登入
    var isLoginBtnPressed = false
    var showingTitleInProgress = false
    
    @IBAction func loginBtnDown(sender:AnyObject){
        
        self.isLoginBtnPressed = true
        
        if !self.idText.hasText(){
            self.showingTitleInProgress = true
            self.idText.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.idText.highlighted = true
        }
        if !self.pwdText.hasText(){
            self.showingTitleInProgress = true
            self.pwdText.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.pwdText.highlighted = true
        }
        
    }
    
    @IBAction func loginBtnUpInside(sender:AnyObject){
        self.isLoginBtnPressed = false
        if(!self.showingTitleInProgress) {
            self.hideTitleVisibleFromFields()
        }
        
        guard let id = idText.text else {return}
        guard let pwd = pwdText.text else {return}
        
        print("\n\(id)\n\(pwd)")
        
        // startAnimation
        startActivityAnimating("Loading...", type: .BallClipRotateMultiple, color: UIColor.whiteColor(), padding: 0)
        
        
        // 使用 Alamofire 呼叫 API 登入後取得 Token
        let logininfo = ["email":id,"password":pwd]
        Alamofire.request(.POST, "http://140.136.155.143/api/auth/login", parameters:logininfo)
            .validate().responseJSON{ response in
                
                switch response.result{
                    
                // 登入成功做的事情
                case .Success:
                    let json = JSON(response.result.value!)
                    
                    self.stopActivityAnimating()
                    
                    if let accessToken = json["token"].string{
                        
                        print(json)
                        
                        print ("成功取得token,並存取")
                        
                        // 存取token 以及基本資料
                        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: ACCESS_TOKEN)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        // 過場動畫
                        // let alertVC = PMAlertController(title: "登入成功", description: "恭喜您,讓我們共同創造美好的回憶", image: UIImage(named: "success.png"), style: .Alert)
                        let alertVC = PMAlertController(title: "登入成功", description: "恭喜您,讓我們共同創造美好的回憶", image: UIImage(named: "shield-1.png"), style: .Alert)
                        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: {
                            
                            // 頁面轉跳
                            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.login()
                        }))
                        
                        self.presentViewController(alertVC, animated: true, completion:self.stopActivityAnimating )
                        
                    }
                    
                    
                    
                // 登入失敗做的事情 沒有碰到網路
                case .Failure(let error):
                    
                    // 我們 server 的問題回報  確定碰到網路 網站回覆行為
                    if let statusCode = response.response?.statusCode{
                        
                        switch(statusCode){
                            
                        case 401:
                            
                            let alertVC = PMAlertController(title: "帳號或密碼錯誤", description: "請重新輸入帳號密碼", image: UIImage(named: "error.png"), style: .Alert)
                            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                            self.presentViewController(alertVC, animated: true, completion: self.stopActivityAnimating)
                            
                        case 422:
                            
                            let alertVC = PMAlertController(title: "填寫欄位有缺少", description: "請確認欄位填寫正確", image: UIImage(named: "list-4.png"), style: .Alert)
                            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                            self.presentViewController(alertVC, animated: true, completion: self.stopActivityAnimating)
                            
                        default:
                            
                            let alertVC = PMAlertController(title: "伺服器問題", description: "抱歉我們伺服器出現問題,請等待我們修復", image: UIImage(named: "server-2.png"), style: .Alert)
                            alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                            self.presentViewController(alertVC, animated: true, completion: self.stopActivityAnimating)
                            
                        }
                    }else if error.code == -1004{
                        
                        let alertVC = PMAlertController(title: "連線失敗", description: "網路發生問題", image: UIImage(named: "cloud-computing-2.png"), style: .Alert)
                        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                        self.presentViewController(alertVC, animated: true, completion: self.stopActivityAnimating)
                        
                        
                    }else{
                        
                        let alertVC = PMAlertController(title: "網路問題", description: "網路發生問題", image: UIImage(named: "cloud-computing-2.png"), style: .Alert)
                        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                        self.presentViewController(alertVC, animated: true, completion: self.stopActivityAnimating)
                        
                    }
                }
        }
    }
    
    // MARK: - FBLogin
    @IBAction func fbBtn_click(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me",
                parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if (error == nil){
                        
                        print("FB_token:\n\(FBSDKAccessToken.currentAccessToken().tokenString)\n")
                        
                        let user = JSON(result)
                        
                        print(user["email"].string)
                        print(user["id"].string)
                        print(user["name"].string)
                        print(user["picture"]["data"]["url"].string)
                        
                    }
                })
        }
    }

    
    
    func showingTitleInAnimationComplete() {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        let displayTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(displayTime, dispatch_get_main_queue(), {
            self.showingTitleInProgress = false
            if(!self.isLoginBtnPressed) {
                self.hideTitleVisibleFromFields()
            }
        })
    }
    func hideTitleVisibleFromFields() {
        self.idText.setTitleVisible(false, animated: true)
        self.pwdText.setTitleVisible(false, animated: true)
        
        self.idText.highlighted = false
        self.pwdText.highlighted = false
    }
    
    
    
    // MARK: - Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.idText) {
            self.validateEmailTextFieldWithText(textField.text)
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
        //        if(textField == self.idText) {
        //            self.validateEmailTextFieldWithText(string)
        //        }
        //        return true
        if(textField == self.idText) {
            
            var txtAfterUpdate:NSString = idText.text! as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            self.validateEmailTextFieldWithText(txtAfterUpdate as String)
            
        }
        return true
        
    }
    
    func validateEmailTextFieldWithText(email: String?) {
        if let email = email {
            if(email.characters.count == 0) {
                self.idText.errorMessage = nil
            }
            else if(!isValidEmail(email)) {
                self.idText.errorMessage = "Email not valid"
                
            } else {
                self.idText.errorMessage = nil
            }
        } else {
            self.idText.errorMessage = nil
        }
    }
    
    func isValidEmail(str:String?) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(str)
    }
}


