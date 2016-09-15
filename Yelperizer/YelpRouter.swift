//
//  YelpRouter.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/5/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class YelpRouter {
    // Mark: Oauth 2.0 and API calls
    // Remove before committing
    private let appID = ""
    private let appSecret = ""
    let searchURL = "https://api.yelp.com/v3/businesses/search?"
    
    private var accessToken: String?
    private var tokenType: String?
    private var expiresIn: Double?
    private var expiresAt: Double?
    
    // Store the values in NSUserDefaults
    private let accessTokenKey = "accessToken"
    private let tokenTypeKey = "tokenType"
    private let expiresInKey = "expiresInKey"
    private let expiresAtKey = "expiresAtKey"
    
    // Getting access token
    init() {
        let date = NSDate()
        let defaults = NSUserDefaults.standardUserDefaults()
        if (initializeWithDefaults()) {
            print("Initialized from user defaults")
        } else {
            print("Initialized")
            Alamofire.request(.POST, "https://api.yelp.com/oauth2/token",
                parameters: ["grant_type": "client_credentials",
                    "client_id": appID,
                    "client_secret": appSecret]
                )
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        print("Validation Successful")
                        
                        let json = JSON(response.result.value!)
                        
                        self.accessToken = json["access_token"].string
                        self.tokenType = json["token_type"].string
                        self.expiresIn = json["expires_in"].double
                        self.expiresAt = self.expiresIn! + date.timeIntervalSince1970
                        
                        // Check if correctly parsed and used later 
                        //print(response)
                        //print(self.accessToken)
                        //print(self.tokenType)
                        //print(self.expiresIn)
                        //print(self.expiresAt)
                        
                        // Write to user defaults
                        print("Writing to user defaults")
                        defaults.setObject(self.accessToken, forKey: self.accessTokenKey)
                        defaults.setObject(self.tokenType, forKey: self.tokenTypeKey)
                        defaults.setDouble(self.expiresIn!, forKey: self.expiresInKey)
                        defaults.setDouble(self.expiresAt!, forKey: self.expiresAtKey)
                        
                        //self.getData()
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    // Initialize with NSUserDefaults instead of JSON
    // Returns true if successfully read the values, false otherwise
    func initializeWithDefaults() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let date = NSDate()
        if let accessToken = defaults.stringForKey(accessTokenKey) {
            print("Loaded Key \(accessToken)")
            self.accessToken = accessToken
            self.tokenType = defaults.stringForKey(tokenTypeKey)
            self.expiresIn = defaults.doubleForKey(expiresInKey)
            self.expiresAt = defaults.doubleForKey(expiresAtKey)
            
            // Check if authorization expired
            if (self.expiresAt < date.timeIntervalSince1970) {
                return false
            }
            return true
        }
        return false
    }
    
    // Fetches JSON from Yelp API
    func getData() {
        let headers = ["Authorization": "\(self.tokenType!) \(self.accessToken!)"]
        
        Alamofire.request(.GET,
            searchURL,
            parameters: ["term": search.searchTerm!, "location": search.location!, "limit": search.limit!],
            headers: headers
            )
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("Data Response Successful")
                    let searchResults = JSON(response.result.value!)
                    search.results = searchResults
                    search.resultsReceived = searchResults["businesses"].count
                    
                    // To remove loading screen and reload results table view
                    NSNotificationCenter.defaultCenter().postNotificationName("receivedSearchData", object: nil)
                case .Failure(let error):
                    print(error)
                }
            }
    }
}
