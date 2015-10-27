//
//  DataViewController.swift
//  BloomsdayApp-iOS
//
//  Copyright © 2015 Bloomsday Run. All rights reserved.
// Auth based on login example at: https://medium.com/ios-os-x-development/a-simple-swift-login-implementation-with-facebook-sdk-for-ios-version-4-0-1f313ae814da#.ch6v32s5w
// Note the above link is for an earlier version of Swift/XCode

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
        
            if FBSDKAccessToken.currentAccessToken() != nil {
                print("FB Token not Nil")
                //For debugging, when we want to ensure that facebook login always happens
                FBSDKLoginManager().logOut()
                //else:
                //return
            }
            
            // FaceBook Auth
            let perms = ["public_profile", "email", "user_friends"]
            //        let fromVC = DBViewController.self()
            var fbToken = ""
            var fbUserID = ""
            print("called application")
            
            FBSDKLoginManager().logInWithReadPermissions(perms, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    // Process error
                    FBSDKLoginManager().logOut()
                    //                failureBlock(error)
                } else if result.isCancelled {
                    // Handle cancellations
                    FBSDKLoginManager().logOut()
                    //                failureBlock(nil)
                } else {
                    // check if user denied a permission
                    var allPermsGranted = true
                    let grantedPermissions = result.grantedPermissions.map( {"\($0)"} )
                    for permission in perms {
                        if !grantedPermissions.contains(permission) {
                            allPermsGranted = false
                            break
                        }
                    }
                    if allPermsGranted {
                        // Do work
                        fbToken = result.token.tokenString
                        fbUserID = result.token.userID
                        print(fbToken)
                        
                        print("Successed")
                        
                        //TODO: Fix SSL auth bug
                        // Switching AWS service manager to authenticated
//                        let loginfo = NSObject(["graph.facebook.com" : fbToken])
//                        let loginfo = ["graph.facebook.com" : fbToken]
                        var logins: NSDictionary = NSDictionary(dictionary: ["graph.facebook.com" : fbToken])
//                        credentialProvider.setLogins(logins);
                        let credentialProvider = AWSCognitoCredentialsProvider(regionType: CognitoRegionType, identityPoolId: CognitoIdentityPoolId)
                        credentialProvider.logins = logins as [NSObject : AnyObject]
                        credentialProvider.refresh()
                        let configuration = AWSServiceConfiguration(
                            region: DefaultServiceRegionType,

                            credentialsProvider: credentialProvider)

                        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
                        
                    } else {
                        print("user did not grant all permissions")
                        print("Failed")
                    }
                }
            })
    
        
        //DB
        //DynamoDBManager.describeTable();
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

