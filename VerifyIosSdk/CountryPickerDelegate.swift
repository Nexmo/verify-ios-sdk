//
//  CountryPickerDelegate.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 09/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation

protocol CountryPickerDelegate  {
    func didSelectCountry(country: [String : AnyObject])
}