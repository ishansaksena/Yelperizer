//
//  FindGroupViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/14/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

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
        let results = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("ResultsTableViewController")
        
        self.navigationController?.pushViewController(results, animated: true)
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
