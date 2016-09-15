//
//  CreateGroupViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/14/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

import UIKit

var create = false

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var codeTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyToClipBoard(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = codeTextField.text
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
