//
//  ResultsTableViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/5/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

/*
 Display Yelp search results, redirect to yelp app and take in votes
 */

import UIKit
import SwiftyJSON

class ResultsTableViewController: UITableViewController {
    
    var firebase = FireBaseManager()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Make bar visible
        self.navigationController?.navigationBarHidden = false
        let titleImage = UIImage(named: "yelp_review_btn_dark")
        let titleImageView = UIImageView(image: titleImage)
        self.navigationItem.titleView = titleImageView
        if search.currentMode == .create {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done,
                                                                                       target: self,
                                                                                       action: #selector(ResultsTableViewController.code))
            search.currentMode = mode.none
            self.firebase.addGroup()
        } else if (search.currentMode == mode.find) {
            //firebase.getGroup()
        }
        
    }
    
    func code() {
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("CreateGroupViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.dataSource = self
        
        // Receive notification from ResultsTableViewController to reload and remove loading view
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ResultsTableViewController.received),
                                                         name: "receivedSearchData",
                                                         object: nil)
        
        // Initial loading screen on table view
        let alert = UIAlertController(title: nil, message: "Punching laser sharks", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // Remove loading view and refresh table
    func received() {
        // Remove loading alert
        dismissViewControllerAnimated(false, completion: nil)
        // Reloading data
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of results
        if let numberReceived = search.resultsReceived {
            return numberReceived
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell

        // Configure the cell...
        let business = search.results!["businesses"][indexPath.row]
        cell.setFor(business)
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    // MARK: Swipe Actions
    // Available options for each restaurant.
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let upVote = UITableViewRowAction(style: .Normal, title: "Upvote") { action, index in
            let business = search.results!["businesses"][indexPath.row]["id"].stringValue
            print("upvoted \(indexPath.row) that's the business \(business)")
            search.votesReceived[business] = 1
            self.firebase.sendVotes()
            self.tableView.reloadData()
        }
        upVote.backgroundColor = UIColor.orangeColor()
        
        let downVote = UITableViewRowAction(style: .Normal, title: "Downvote") { action, index in
            let business = search.results!["businesses"][indexPath.row]["id"].stringValue
            print("downvoted \(indexPath.row) that's the business \(business)")
            search.votesReceived[business] = -1
            self.firebase.sendVotes()
            self.tableView.reloadData()
        }
        downVote.backgroundColor = UIColor.redColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share  \(indexPath.row)")
            let url = NSURL(string: search.results!["businesses"][indexPath.row]["url"].stringValue)
            let activityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            self.navigationController?.presentViewController(activityViewController, animated: true) {
                // ...
            }
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [share, downVote, upVote]
    }
    
    // Show actions when user swipes left on a restaurant
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    // MARK: Open in app
    // Open in yelp app or safari when user selects a restaurant.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlFromJSON = search.results!["businesses"][indexPath.row]["url"].string
        let url = NSURL(string: urlFromJSON!)
        // Open with Yelp or safari
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        } else {// Show yelp app if not installed
            UIApplication.sharedApplication().openURL(NSURL(string: "https://appsto.re/us/om2-q.i")!)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
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




