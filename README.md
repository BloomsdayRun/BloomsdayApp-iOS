Here is a basic app for authenticating a user with AWS Cognito using their Facebook login, then sending some mock location data to a DynamoDB instance. Expected behavior: user opens app, they are redirected to Facebook's login screen, enter their credentials, then go back to StartViewController (the Username and Password fields in StartViewController don't do anything). Then they click Submit and go to a screen where they can send a mock GPS coordinate to a DynamoDB table, and scan the table to standard output.

# Build Process
1. AWS dependencies are defined in Podfile. To install these, ensure you have Cocoa Pods installed:
    ```
    sudo gem install cocoapods
    ```
Then install the pods with:
    ```
    pod install
    ```
Once you've installed the AWS SDK, it is important to open <Project_Name>.xcworkspace, NOT <Project_Name>.xcodeproj

2. Download the Facebook SDK from https://developers.facebook.com/docs/ios . Drag FBSDKCoreKit.framework and FBSDKLoginKit.framework into the Xcode project under the Frameworks folder. Select "Create Groups" and "Copy Items if Needed".

3. (In AWS Console, already done) Set up Amazon IAM and DynamoDB. In Constants.swift, fill in all the relevant constants:
    ```
    let CognitoRegionType = AWSRegionType.INSERT
    let DefaultServiceRegionType = AWSRegionType.INSERT
    let CognitoIdentityPoolId = "INSERT"
    let AWSSampleDynamoDBTableName = "INSERT"
    ```
Ensure you have a a Cognito Identity Pool in which the authenticated role has write and scan permissions on AWSSampleDynamoDBTableName. Authentication for this pool should be provided by Facebook, and unauthenticated usage should be prohibited.

    

