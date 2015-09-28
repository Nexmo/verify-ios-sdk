//
//  CheckViewController.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 24/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController, PageIndexable {

    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var statusImage: UIImageView!
    
    var index: Int {
        get { return 1 }
    }
    
    private weak var parentPageController : VerifyPageViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     convenience init(parent: VerifyPageViewController) {
        self.init(nibName: "CheckViewController", bundle: nil)
        parentPageController = parent

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusImage.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (pinField.isFirstResponder() && (event?.allTouches()?.first)?.view != pinField) {
            pinField.resignFirstResponder()
        }
    }
    
    @IBAction func checkPinCode(sender: UIButton) {
        if (pinField.text?.characters.count != 4) {
            UIAlertView(title: "Pin code wrong length", message: "Your pin code should be 4 digits long.", delegate: nil, cancelButtonTitle: "Oh, fiddlesticks!").show()
            return
        }
        
        if (pinField.isFirstResponder()) {
            pinField.resignFirstResponder()
        }
        
        parentPageController.checkPinCode()
    }
}
