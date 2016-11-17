//
//  CountryPickerController.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 09/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit

class CountryPickerController : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    let view = UIPickerView()
    var delegate : CountryPickerDelegate?
    
    // MARK:
    // MARK: Init
    
    override init() {
        super.init()
        view.delegate = self
        view.dataSource = self
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
        return NSAttributedString(string: Countries.list[row]["country"] as! String, attributes: [:])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectCountry(Countries.list[row])
    }
}
