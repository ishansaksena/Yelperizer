//
//  LimitViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/6/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

/*
 Simple view controller to get the limit on the number of options
 */

import UIKit

class LimitViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var limitTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        limitTextField.delegate = self
        //self.limitTextField.becomeFirstResponder()
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barButtonDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self,
                                              action: #selector(self.nextPage))
        
        toolbarDone.items = [barButtonDone]
        limitTextField.inputAccessoryView = toolbarDone

    }
    func nextPage() {
        NSNotificationCenter.defaultCenter().postNotificationName("enteredLimit", object: nil)
        //limitTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !(textField.text?.isEmpty)! {
            search.limit = Int(textField.text!)
        }
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
