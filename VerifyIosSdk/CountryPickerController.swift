//
//  CountryPickerController.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 09/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit

class CountryPickerController : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    let view = UIPickerView()
    var delegate : CountryPickerDelegate?
    
    override init() {
        super.init()
        view.delegate = self
        view.dataSource = self
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
        return NSAttributedString(string: Countries.list[row]["country"] as! String, attributes: [:])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectCountry(Countries.list[row])
    }
}