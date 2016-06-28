//
//  signUpVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/28.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class signUpVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var emailTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var repeatPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var fullnameTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bioTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var webTxt: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var signBtn: UIButton!
    
    
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTextTheme()
        self.emailTxt.becomeFirstResponder()
    }


    func setTextTheme(){
        
        self.signBtn.layer.borderColor = lightGreyColor.CGColor
        self.signBtn.layer.borderWidth = 1
        self.signBtn.setTitleColor(overcastBlueColor, forState: .Highlighted)
        
        
        self.applySkyscannerThemeWithIcon(self.emailTxt)
//        self.emailTxt.iconText = "\u{f007}"
        self.emailTxt.iconText = "\u{f1d8}"
        self.emailTxt.placeholder = "Account"
        self.emailTxt.selectedTitle = "enter your email address"
        self.emailTxt.title = "account"
        
        self.applySkyscannerThemeWithIcon(self.passwordTxt)
        self.passwordTxt.iconText = "\u{f084}"
        self.passwordTxt.placeholder = "Password"
        self.passwordTxt.selectedTitle = "enter your Password"
        self.passwordTxt.title = "Password"
        
        self.applySkyscannerThemeWithIcon(self.repeatPassword)
        self.repeatPassword.iconText = "\u{f084}"
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
        
        self.emailTxt.delegate = self
        self.passwordTxt.delegate = self
        self.repeatPassword.delegate = self
        self.fullnameTxt.delegate = self
        self.bioTxt.delegate = self
        self.webTxt.delegate = self
        
        
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
        self.emailTxt.setTitleVisible(false, animated: true)
        self.passwordTxt.setTitleVisible(false, animated: true)
        self.repeatPassword.setTitleVisible(false, animated: true)
        self.fullnameTxt.setTitleVisible(false, animated: true)
        self.bioTxt.setTitleVisible(false, animated: true)
        self.webTxt.setTitleVisible(false, animated: true)
        
        
        self.emailTxt.highlighted = false
        self.passwordTxt.highlighted = false
        self.repeatPassword.highlighted = false
        self.fullnameTxt.highlighted = false
        self.bioTxt.highlighted = false
        self.webTxt.highlighted = false
    }
    
    // MARK: - Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.emailTxt) {
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
        
        
        if(textField == self.emailTxt) {
            
            var txtAfterUpdate:NSString = emailTxt.text! as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            self.validateEmailTextFieldWithText(txtAfterUpdate as String)
            
        }
        return true
        
    }
    
    func validateEmailTextFieldWithText(email: String?) {
        if let email = email {
            if(email.characters.count == 0) {
                self.emailTxt.errorMessage = nil
            }
            else if(!isValidEmail(email)) {
                self.emailTxt.errorMessage = NSLocalizedString("Email not valid", tableName: "SkyFloatingLabelTextField", comment: " ")
                
            } else {
                self.emailTxt.errorMessage = nil
            }
        } else {
            self.emailTxt.errorMessage = nil
        }
    }
    
    func isValidEmail(str:String?) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(str)
        
    }
    
    // MARK: - IBAction
    
    @IBAction func signUpBtn_down(sender: AnyObject) {
        self.isSignUpBtnPressed = true
        
        if !self.emailTxt.hasText(){
            self.showingTitleInProgress = true
            self.emailTxt.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.emailTxt.highlighted = true
        }
        
        if !self.passwordTxt.hasText(){
            self.showingTitleInProgress = true
            self.passwordTxt.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.passwordTxt.highlighted = true
        }
        
        if !self.repeatPassword.hasText(){
            self.showingTitleInProgress = true
            self.repeatPassword.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.repeatPassword.highlighted = true
        }
        
        if !self.fullnameTxt.hasText(){
            self.showingTitleInProgress = true
            self.fullnameTxt.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.fullnameTxt.highlighted = true
        }
        
        if !self.bioTxt.hasText(){
            self.showingTitleInProgress = true
            self.bioTxt.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.bioTxt.highlighted = true
        }
        
        if !self.webTxt.hasText(){
            self.showingTitleInProgress = true
            self.webTxt.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.webTxt.highlighted = true
        }
        
    }
    
    
    @IBAction func signUpBtn_UpInside(sender: AnyObject) {
        
        self.isSignUpBtnPressed = false
        
        if(!self.showingTitleInProgress) {
            self.hideTitleVisibleFromFields()
        }
        
    }
    
}
