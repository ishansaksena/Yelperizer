//
//  SearchTermViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/6/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

/*
 Simple view controller to get the search term
 */

import UIKit

class SearchTermViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTermTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTermTextField.delegate = self
        self.searchTermTextField.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        search.searchTerm = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Pressed return on search term ")
        NSNotificationCenter.defaultCenter().postNotificationName("enteredSearchTerm", object: nil)
        searchTermTextField.resignFirstResponder()
        return false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchTermTextField.resignFirstResponder()
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
