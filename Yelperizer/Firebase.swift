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

class FireBaseManager {
    var votes: [FIRDataSnapshot]! = []
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
            self.votes.append(snapshot)
            print("Snapshot received")
            print(self.votes)
            //self.clientTable.insertRowsAtIndexPaths([NSIndexPath(forRow: self.votes.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    // Write to Firebase database
    func sendMessage(data: [String: String]) {
        var voteData = data
        voteData[Constants.MessageFields.name] = AppState.sharedInstance.displayName
        if let photoUrl = AppState.sharedInstance.photoUrl {
            voteData[Constants.MessageFields.photoUrl] = photoUrl.absoluteString
        }
        // Push data to Firebase Database
        self.ref.child("votes").childByAutoId().setValue(voteData)
    }
}