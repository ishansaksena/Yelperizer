//
//  FindGroupViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/14/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

// Fetch existing group from Firebase

import UIKit

class FindGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var groupCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupCode.delegate = self
        self.navigationController?.navigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Check if valid data received for group code 
        if groupCode.text?.characters.count == 20 {// Valid length
            search.currentMode = mode.find
            currentKey = groupCode.text!
            let firebase = FireBaseManager()
            firebase.getGroup()
            let results = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("ResultsTableViewController")
        
            self.navigationController?.pushViewController(results, animated: true)
        } else {// Invalid code entered
            let message = "Please enter a valid code"
            let alert = UIAlertController(title: "You're clownin'", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
