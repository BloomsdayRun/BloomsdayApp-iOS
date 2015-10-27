//
//  StartViewController.swift
//  BloomsdayApp-iOS
//
//  Copyright © 2015 Bloomsday Run. All rights reserved.
// Auth based on login example at: https://medium.com/ios-os-x-development/a-simple-swift-login-implementation-with-facebook-sdk-for-ios-version-4-0-1f313ae814da#.ch6v32s5w
// Note the above link is for an earlier version of Swift/XCode

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    var fbToken = ""
    var fbUserID = ""

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
            //Other options for FB permissions: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"
            let perms = ["public_profile", "email", "user_friends"]
            
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
                        self.fbToken = result.token.tokenString
                        self.fbUserID = result.token.userID
                        print(self.fbToken)
                        
                        print("Successed")
                        
                        // Set the AWS credentials providerot use Facebook's auth token
                        let logins: NSDictionary = NSDictionary(dictionary: ["graph.facebook.com" : self.fbToken])
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
//            Proceed only if FB authentication succeeds
            if (fbUserID == "") {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    //Override prepareForSegue to pass username to DB controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let dest = segue.destinationViewController as! DBViewController
        dest.fbUserID = self.fbUserID
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

