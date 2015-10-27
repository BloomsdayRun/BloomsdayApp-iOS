//
//  DBViewController.swift
//  BloomsdayApp-iOS
//
//  Copyright © 2015 Bloomsday Run. All rights reserved.
//

import UIKit

class DBViewController: UIViewController {
    
    var pageViewController: UIPageViewController?
    var fbUserID: String?
    
    @IBOutlet var latitude: UITextField!
    @IBOutlet var longitude: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded DBVC")
        print("User = " + fbUserID!);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSubmitLocation(sender: AnyObject) {
        print("You must want to send: " + latitude.text! + " - " + longitude.text!)
        let lat = (latitude.text! as NSString).floatValue
        let lon = (longitude.text! as NSString).floatValue
        if (lat == 0 || lon == 0) {
            print("Those are some unrealistic GPS coordinates (did do you try to pass letter values)?")
        } else if (lat > 90 || lat < -90) {
            print("Invalid latitude")
        } else if (lon > 180 || lon < -180) {
            print("Invalid longitude")
        } else {
            sendDataToServer(lat, longitude: lon)
        }
    }
    
    @IBAction func scanDataFromServer(sender: AnyObject) {
        print("Top 20 From DynamoDB")
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.limit = 20;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()

        dynamoDBObjectMapper.scan(DDBTableRow.self, expression: queryExpression).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                for item in paginatedOutput.items as! [DDBTableRow] {
                    let a = String(item.Time!)
                    let b = String(item.Latitude!)
                    let c = String(item.Longitude!)
                    print("retrieved: " + item.Username! + " - " + a + " - " + b + " - " + c )
                }
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })
        
    }
    
    func sendDataToServer(latitude: NSNumber, longitude: NSNumber) {
        print(latitude)
        print(longitude)
        let timestamp = NSDate().timeIntervalSince1970
        
        // Create data model
        let tableRow = DDBTableRow();
        tableRow.Username = fbUserID!;
        tableRow.Latitude = latitude;
        tableRow.Longitude = longitude;
        tableRow.Time = timestamp;
        
        // Push the data to the server
        let tasks = NSMutableArray()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        tasks.addObject(dynamoDBObjectMapper.save(tableRow) )
        // Foreach task (i.e., pending save execution), execute and log if success/error
        // TODO: See if there's a better pattern for sending only one element
        AWSTask( forCompletionOfAllTasks: tasks as [AnyObject] ) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            } else{
                print("Success")
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            return nil
        })
    }
    
    
}

