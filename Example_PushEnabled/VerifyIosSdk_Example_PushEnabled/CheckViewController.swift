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
    
    fileprivate weak var parentPageController : VerifyPageViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (pinField.isFirstResponder && (event?.allTouches?.first)?.view != pinField) {
            pinField.resignFirstResponder()
        }
    }
    
    @IBAction func checkPinCode(_ sender: UIButton) {
        if (pinField.text?.characters.count != 4) {
            let controller = UIAlertController(title: "Pin code wrong length", message: "Your pin code should be 4 digits long.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oh, fiddlesticks!", style: .default, handler: nil)
            controller.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
            return
        }
        
        if (pinField.isFirstResponder) {
            pinField.resignFirstResponder()
        }
        
        parentPageController.checkPinCode()
    }
}
