//
//  Firebase.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/15/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

// Handles all interactions with Firebase

import Foundation
import Firebase
import FirebaseDatabase

var currentKey = "key"

class FireBaseManager {
    var snaps: [FIRDataSnapshot]! = []
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!

    init() {
        configureDatabase()
    }
    
    deinit {
        self.ref.child("messages").removeObserverWithHandle(_refHandle)
    }
    
    // Used when user chooses find group
    // Fetch search parameters and votes with the group ID
    func getGroup() {
        ref.child("groups").child(currentKey).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            // Get search parameters
            search.searchTerm = snapshot.value!["searchTerm"] as? String
            let limit = snapshot.value!["limit"] as? String
            search.limit = Int(limit!)
            search.location = snapshot.value!["location"] as? String
            // ...
            print(search)
            yelpRouter = YelpRouter()
            yelpRouter.getData()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Used when the user chooses find group
    // Fetch votes under the current key
    func getVotes() {
        self.ref.child("votes").child(currentKey).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            // Get votes
            for name in search.votesReceived.keys {
                search.votesReceived[name] = (snapshot.value![name]) as? Int
            }
            // Data received
            NSNotificationCenter.defaultCenter().postNotificationName("receivedSearchData", object: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Set reference and set up listeners
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("votes").observeEventType(.ChildChanged, withBlock: { (snapshot) -> Void in
            self.snaps.append(snapshot)
            print("Snapshot received")
            //print(self.snaps)
            print(snapshot)
            for i in 0...(search.resultsReceived! - 1) {
                let key = search.results!["businesses"][i]["id"].stringValue
                //search.votesReceived[key]! += snapshot.value![key] as! Int
                print(snapshot.value![key] as! Int)
            }
            self.sendVotes()
        })
    }
    
    
    // Rewrite votes in database
    func sendVotes() {
        let childUpdates = ["/votes/\(currentKey)": search.votesReceived]
        ref.updateChildValues(childUpdates)
    }
    
    // Write to Firebase database
    func addGroup() {
        let limit = String(search.limit!)
        var groupData = ["searchTerm": search.searchTerm!, "location": search.location!, "limit":limit]
        
        groupData[Constants.MessageFields.name] = AppState.sharedInstance.displayName
        // Push data to Firebase Database
        let key = ref.child("groups").childByAutoId().key
        currentKey = key
        
        let childUpdates = ["/groups/\(key)": groupData,
                            "/votes/\(key)": search.votesReceived]
        print("The key for the write is: \(key)")
        ref.updateChildValues(childUpdates as [NSObject : AnyObject])
    }

}