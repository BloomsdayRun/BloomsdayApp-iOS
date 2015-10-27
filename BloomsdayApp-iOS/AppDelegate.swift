//
//  AppDelegate.swift
//  BloomsdayApp-iOS
//
//  Copyright © 2015 Bloomsday Run. All rights reserved.
//
import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var facebookReadPermissions = ["public_profile", "email", "user_friends"]


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        //Launch with facebook (moved to DataViewController)
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //Optionally add to ensure your credentials are valid:
//        FBSDKLoginManager.renewSystemCredentials { (result:ACAccountCredentialRenewResult, error:NSError!) -> Void in
//        loginToFacebookWithSuccess(sb, andFailure: fb)
//       print(fbToken)
//        loginToFacebookWithSuccess(sb, andFailure: fb )
        //        var logins: NSDictionary = NSDictionary(dictionary: ["graph.facebook.com" : fbToken])
        
        
        
//         Make AWS use the credentials furnished in constants
//        let credentialProvider = AWSCognitoCredentialsProvider(regionType: CognitoRegionType, identityPoolId: CognitoIdentityPoolId)
        

//        let configuration = AWSServiceConfiguration(
//            region: DefaultServiceRegionType,
//            credentialsProvider: credentialProvider)
        
//        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        return true
    }
    
    //TODO: Actual success/fail blocks
    func sb() -> () {
//        return "sb";
    }
    
    func fb(_: (NSError?)) -> () {
//        return "fb";
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        //Even though the Facebook SDK can make this determinitaion on its own,
        //let's make sure that the facebook SDK only sees urls intended for it,
        //facebook has enough info already!
//        let isFacebookURL = url.scheme != nil && url.scheme.hasPrefix("fb\(FBSDKSettings.appID())") && url.host == "authorize"
//        if isFacebookURL {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//        }
//        return false
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        //App activation code
        FBSDKAppEvents.activateApp()
    }
    
    //Other options for FB permissions: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

//    func applicationDidBecomeActive(application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

