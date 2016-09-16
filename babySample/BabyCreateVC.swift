//
//  BabyCreateVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/9/16.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class BabyCreateVC: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate{
    
    let boolds = ["A","B","AB","O"]
    
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var bloodTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var dateTextFiled: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        bloodTextField.inputView = pickerView
        
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
    
    @IBAction func bloodEditing(sender: SkyFloatingLabelTextFieldWithIcon) {
        

        
        
        
    }
    
    
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
    
    
}
