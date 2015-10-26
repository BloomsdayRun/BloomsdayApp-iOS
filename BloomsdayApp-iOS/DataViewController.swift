//
//  DataViewController.swift
//  BloomsdayApp-iOS
//
//  Copyright © 2015 Bloomsday Run. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""

    //Params
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("The view loaded")
        username.delegate = self
    }
    
//    func textFieldDidChange(textView: UITextField) {
//        print(textView.text)
//    }
    
    //drag listeners from connections inspector in storyboard
    @IBAction func changedTextField(sender: UITextField) {
        print(sender.text)
    }
    
    //when clicking submit, segue must first validate credentials
    //TODO: Authenticate credentials with Cognito
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "nextView" {
            if (username.text! == "a") {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    @IBAction func onSubmit(sender: UIButton) {
        print("button was tapped")
        print("uname = " + username.text!);
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }


}

