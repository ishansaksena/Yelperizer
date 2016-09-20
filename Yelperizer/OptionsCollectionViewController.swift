//
//  OptionsCollectionViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/7/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

/* 
 Initial set of options that may include: 
 1. Joining groups
 2. Creating groups
 3. Signing in with a different account
 4. Simple search without groups
 */

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "OptionCell"

class OptionsCollectionViewController: UICollectionViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "Yelperizer"
        let login = FIRAuth.auth()?.currentUser?.displayName
        print()
        print("The current user is: ", login)
        print()
        if login == nil {
            let vc = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewControllerWithIdentifier("SignInViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(OptionCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        // Load 4 initial options
        setDefaultOptions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items
        return options.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! OptionCollectionViewCell
    
        // Configure the cell
        // Data
        cell.icon.text = options[indexPath.row].icon
        cell.action.text = options[indexPath.row].actions
        
        // Appearance
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 45
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Party on! \(indexPath.row)")
        switch indexPath.row {
        case 0:// Create new group
            print("Creating new group")
            search.currentMode = mode.create
            let searchController = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewControllerWithIdentifier("SearchPageViewController")
            self.navigationController?.pushViewController(searchController, animated: true)
            
        case 1:// Join Group
            print("Join group")
            
            let vc = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewControllerWithIdentifier("FindGroupViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 2:// Login again?
            print("Login again?")
            let vc = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewControllerWithIdentifier("SignInViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 3:// Logout
            print("Logout")
            self.signOut()
            
        case 4:// Search
            print("Search")
            search.currentMode = mode.search
            let vc = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewControllerWithIdentifier("SearchPageViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("Invalid option selected from initial options")
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: Firebase
    func signOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            let alertController = UIAlertController(title: "Ciao!",
                                                    message: "You're all signed out!",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("Signed out")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }

}
