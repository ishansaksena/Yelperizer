//
//  Firebase.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/15/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

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
    
    // Set reference and set up listeners
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("votes").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.snaps.append(snapshot)
            print("Snapshot received")
            //print(self.snaps)
            print(snapshot)
            var voteKeys = [String]()
            for i in 0...(search.resultsReceived! - 1) {
                let key = search.results!["businesses"][i]["id"].stringValue
                search.votesReceived[key]! += snapshot.value![voteKeys[0]] as! Int
                voteKeys.append(key)
            }
            print(voteKeys)
            print(snapshot.value![voteKeys[0]])
            
        })
    }
    
    // Rewrite votes in database
    func sendVotes() {
        let childUpdates = ["/votes/\(currentKey)": search.votesReceived]
        ref.updateChildValues(childUpdates)
    }
    
    // Write to Firebase database
    func addGroup() {
        let limit = String(search.limit)
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