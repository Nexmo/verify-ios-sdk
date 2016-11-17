//
//  StartScreenViewController.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 24/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit
import NexmoVerify

class StartViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, PageIndexable {
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    weak var parentPageViewController : VerifyPageViewController!
    
    var index: Int = 0
    var currentCountry = Countries.list[2] as [String : AnyObject]
    
    // MARK:
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(parent: VerifyPageViewController) {
        self.init(nibName: "StartViewController", bundle: nil)
       
        parentPageViewController = parent
    }
    
    // MARK:
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setupView() {
        let countryPickerView = UIPickerView()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.backgroundColor = Colors.nexmoDarkBlue
     
        countryField.inputView = countryPickerView
    }
    
    // MARK:
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (phoneNumberField.isFirstResponder && (event?.allTouches?.first)?.view != phoneNumberField) {
            phoneNumberField.resignFirstResponder()
            return
        }
        
        if (countryField.isFirstResponder && (event?.allTouches?.first)?.view != countryField) {
            countryField.resignFirstResponder()
            return
        }
    }

    // MARK:
    // MARK: Action
    
    @IBAction func beginVerification(_ sender: UIButton) {
        if (countryField.isFirstResponder) {
            countryField.resignFirstResponder()
        }
        
        if (phoneNumberField.isFirstResponder) {
            phoneNumberField.resignFirstResponder()
        }
        
        parentPageViewController.beginVerification()
    }
    
    // Mark:
    // Mark: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Countries.list.count
    }
    
    // Mark:
    // Mark: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Countries.list[row]["country"] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCountry = Countries.list[row]
        countryField.text = describeCountry(currentCountry)
    }
    
    func describeCountry(_ country: [String : AnyObject]) -> String {
        if let prefix_list = country["int_prefix"] as? NSArray, let int_prefix = prefix_list[0] as? String {
            return "\(country["country_code"] as! String) (+\(int_prefix))"
        }
        
        return country["country_code"] as! String
    }
}
