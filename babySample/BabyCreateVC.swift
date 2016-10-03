//
//  BabyCreateVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/16.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import FontAwesome_swift
import PMAlertController



class BabyCreateVC: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let boolds = ["A","B","AB","O" , "Rh+", "Rh-" ,"Hh","P"]
    
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bloodTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var dateTextFiled: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var babyImg: UIImageView!
    
    
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    let lightGreyColor = UIColor(r: 197, g: 205, b: 205)
    let darkGreyColor = UIColor(r: 52, g: 42, b: 61)
    let overcastBlueColor = UIColor(r: 0, g: 197, b: 204)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // picker
        let pickerView = UIPickerView()
        pickerView.delegate = self
        bloodTextField.inputView = pickerView
        
        
        // Set View
        setView()
        
    }
    
    
    func setView () {
        
        // View鍵盤隱藏
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // image radious
        babyImg.layer.cornerRadius = babyImg.frame.size.width/2
        babyImg.clipsToBounds = true
        
        // 手勢添加
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(self.pickImg))
        imgTap.numberOfTapsRequired = 1
        babyImg.userInteractionEnabled = true
        babyImg.addGestureRecognizer(imgTap)
        
        // UISet
        backBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        backBtn.setTitle(String.fontAwesomeIconWithCode("fa-chevron-down"), forState: .Normal)
        
        self.createBtn.layer.borderColor = lightGreyColor.CGColor
        self.createBtn.layer.borderWidth = 1
        self.createBtn.setTitleColor(overcastBlueColor, forState: .Highlighted)
        
        
        self.applySkyscannerThemeWithIcon(self.nameTextField)
        self.nameTextField.iconText = "\u{f007}"
        self.nameTextField.placeholder = "Name"
        self.nameTextField.selectedTitle = "enter your baby's name"
        self.nameTextField.title = "Name"
        
        self.applySkyscannerThemeWithIcon(self.bloodTextField)
        self.bloodTextField.iconText = "\u{f084}"
        self.bloodTextField.placeholder = "Password"
        self.bloodTextField.selectedTitle = "enter your Password"
        self.bloodTextField.title = "Password"
        
        self.applySkyscannerThemeWithIcon(self.bloodTextField)
        self.bloodTextField.iconText = "\u{f043}"
        self.bloodTextField.placeholder = "Blood"
        self.bloodTextField.selectedTitle = "choose your baby's blood"
        self.bloodTextField.title = "Blood"
        
        self.applySkyscannerThemeWithIcon(self.dateTextFiled)
        self.dateTextFiled.iconText = "\u{f133}"
        self.dateTextFiled.placeholder = "birthday"
        self.dateTextFiled.selectedTitle = "choose your baby's birthday"
        self.dateTextFiled.title = "birthday"
        
        self.nameTextField.delegate = self
        self.bloodTextField.delegate = self
        self.dateTextFiled.delegate = self
        
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
        
        self.nameTextField.setTitleVisible(false, animated: true)
        self.bloodTextField.setTitleVisible(false, animated: true)
        self.dateTextFiled.setTitleVisible(false, animated: true)
        
        self.nameTextField.highlighted = false
        self.bloodTextField.highlighted = false
        self.dateTextFiled.highlighted = false
        
    }
    
    
    // MARK: - SkyFloatingLabelTextFieldWithIcon
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
    
    
    // MARK: - TextFiled Delegate
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder! {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == self.nameTextField) {
            var txtAfterUpdate:NSString = nameTextField.text! as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            self.validateNameTextFieldWithText(txtAfterUpdate as String)
            
        }
        
        return true
    }
    
    func validateNameTextFieldWithText(name: String?) {
        
        if let name = name {
            if(name.characters.count == 0) {
                self.nameTextField.errorMessage = "please enter your baby's name"
            }else {
                self.nameTextField.errorMessage = nil
            }
        }
    }
    
    // MARK: - Image picker controller
    func pickImg () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        picker.navigationBar.tintColor = UIColor.whiteColor()
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        babyImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return boolds.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return boolds[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodTextField.text = boolds[row]
    }
    
    
    
    // MARK: - IBAction
    
    
    
    
    @IBAction func birthEditing(sender: SkyFloatingLabelTextFieldWithIcon) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(BabyCreateVC.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    // Blood Picker
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateTextFiled.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    @IBAction func createBtnDown(sender: AnyObject) {
        
        self.isSignUpBtnPressed = true
        
        if !self.nameTextField.hasText(){
            self.showingTitleInProgress = true
            self.nameTextField.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.nameTextField.highlighted = true
        }
        
        if !self.bloodTextField.hasText(){
            self.showingTitleInProgress = true
            self.bloodTextField.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.bloodTextField.highlighted = true
        }
        
        if !self.dateTextFiled.hasText(){
            self.showingTitleInProgress = true
            self.dateTextFiled.setTitleVisible(true, animated: true, animationCompletion: self.showingTitleInAnimationComplete)
            self.dateTextFiled.highlighted = true
        }
    }
    
    
    @IBAction func createBtnUpInside(sender: AnyObject) {
        
        self.isSignUpBtnPressed = false
        
        
        
        if(!self.showingTitleInProgress) {
            self.hideTitleVisibleFromFields()
        }
        guard let name = nameTextField.text else {return}
        guard let blood = bloodTextField.text else {return}
        guard let birth = dateTextFiled.text else {return}
        
        guard let Img = babyImg.image else {return}
        
        // upload data
        ApiService.shareInstance.baby_create(name, birth: birth, blood: blood, babyImg: Img) { (response) in
            print(response)
            
        }
        
        
        // 之後有時間用協定改寫
        let alertVC = PMAlertController(title: "寶寶創建成功", description: "恭喜您,家中又多了一位新成員了～", image: UIImage(named: "pacifier.png"), style: .Alert)
        
        // 轉跳 feed Controller
        alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action:{
            let tabbar = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! tabVC
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabbar
            
        }))
        
        self.presentViewController(alertVC, animated: true, completion:nil)
        
        
    }
    
    
    @IBAction func dimissVC(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
