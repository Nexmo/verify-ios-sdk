//
//  StartScreenViewController.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 24/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit
import VerifyIosSdk

class StartViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, PageIndexable {
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    weak var parentPageViewController : VerifyPageViewController!
    
    var index: Int {
        get { return 0 }
    }
    
    var currentCountry = Countries.list[2] as [String : AnyObject]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(parent: VerifyPageViewController) {
        self.init(nibName: "StartViewController", bundle: nil)
        parentPageViewController = parent

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryPickerView = UIPickerView()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.backgroundColor = Colors.nexmoDarkBlue
        countryField.inputView = countryPickerView
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (phoneNumberField.isFirstResponder() && (event?.allTouches()?.first)?.view != phoneNumberField) {
            phoneNumberField.resignFirstResponder()
            return
        }
        
        if (countryField.isFirstResponder() && (event?.allTouches()?.first)?.view != countryField) {
            countryField.resignFirstResponder()
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginVerification(sender: UIButton) {
        print("beginVerification")
        
        if (countryField.isFirstResponder()) {
            countryField.resignFirstResponder()
        }
        
        if (phoneNumberField.isFirstResponder()) {
            phoneNumberField.resignFirstResponder()
        }
        
        parentPageViewController.beginVerification()
    }
    
    @IBAction func logoutUser(sender: AnyObject) {
        parentPageViewController.logoutUser()
    }
    
    @IBAction func standaloneVerification(sender: AnyObject) {
        parentPageViewController.standaloneVerification()
    }
    
    // Mark: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Countries.list.count
    }
    
    // Mark: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Countries.list[row]["country"] as! String, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCountry = Countries.list[row]
        countryField.text = describeCountry(currentCountry)
    }

    func describeCountry(country: [String : AnyObject]) -> String {
        if let prefix_list = country["int_prefix"] as? NSArray {
            if prefix_list.count > 0 {
                if let int_prefix = prefix_list[0] as? String {
                    return "\(country["country_code"] as! String) (+\(int_prefix))"
                }
            }
        }
        
        return country["country_code"] as! String
    }
}