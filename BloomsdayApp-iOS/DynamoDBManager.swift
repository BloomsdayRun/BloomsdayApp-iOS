//
//  DynamoDBManager.swift
//  BloomsdayApp-iOS
//
//  Copyright © 2015 Bloomsday Run. All rights reserved. Based on the AWS Sample code:
// https://github.com/awslabs/aws-sdk-ios-samples/tree/master/DynamoDBObjectMapper-Sample/Swift
//

//Used to create Table in DDB
import Foundation

class DynamoDBManager : NSObject {
    class func describeTable() -> AWSTask {
        let dynamoDB = AWSDynamoDB.defaultDynamoDB()
        
        // See if the test table exists.
        let describeTableInput = AWSDynamoDBDescribeTableInput()
        describeTableInput.tableName = AWSSampleDynamoDBTableName
        return dynamoDB.describeTable(describeTableInput)
    }
    
}

//Table row for location data
class DDBTableRow : AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    
    var Username:String?
//    var GameTitle:String?
    
    //set the default values of scores, wins and losses to 0
    var Latitude:NSNumber? = 0
    var Longitude:NSNumber? = 0
    var Time:NSNumber? = 0
    
    //should be ignored according to ignoreAttributes
    var internalName:String?
    var internalState:NSNumber?
    
    class func dynamoDBTableName() -> String! {
        return AWSSampleDynamoDBTableName
    }
    
    class func hashKeyAttribute() -> String! {
        return "Username"
    }
    
//    class func rangeKeyAttribute() -> String! {
//        return "GameTitle"
//    }
    
    class func ignoreAttributes() -> Array<AnyObject>! {
        return ["internalName","internalState"]
    }
    
    //MARK: NSObjectProtocol hack
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
}

