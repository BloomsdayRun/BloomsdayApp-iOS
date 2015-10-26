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
        
        //DB
        DynamoDBManager.describeTable();
        // Create data model
        let tableRow = DDBTableRow();
        tableRow.Username = "Bob";
        tableRow.Latitude = 49.753153;
        tableRow.Longitude = 27.622222;
        tableRow.Time = 10029459;
        
        // Push the data to the server
        let tasks = NSMutableArray()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        tasks.addObject(dynamoDBObjectMapper.save(tableRow) )
        AWSTask( forCompletionOfAllTasks: tasks as [AnyObject] ) .continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            } else{
                print("No error")
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
//            self.refreshList(true)
            return nil
        })
        
        //
        
        //Get data
        print("Scan")
        
        let queryExpression = AWSDynamoDBScanExpression()
//        queryExpression.exclusiveStartKey = self.lastEvaluatedKey
        queryExpression.limit = 20;
        dynamoDBObjectMapper.scan(DDBTableRow.self, expression: queryExpression).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task:AWSTask!) -> AnyObject! in
            
//            if self.lastEvaluatedKey == nil {
//                self.tableRows?.removeAll(keepCapacity: true)
//            }
//            
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                for item in paginatedOutput.items as! [DDBTableRow] {
//                    self.tableRows?.append(item)
                    print("retrieved: " + item.Username! + " - " + String(item.Time!) )
                }
//
//                self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey
//                if paginatedOutput.lastEvaluatedKey == nil {
//                    self.doneLoading = true
//                }
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            self.tableView.reloadData()
            
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
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

