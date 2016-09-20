//
//  SearchParameters.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/6/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

// Store all search related parameters and results

import Foundation
import SwiftyJSON

struct Search {
    var searchTerm: String?
    var location: String?
    var limit: Int?
    var results: JSON?
    var resultsReceived: Int?
    var votesReceived = [String: Int]()
    var imageURLs = [String: UIImage]()
    var currentMode = mode.none
}

var search = Search()

enum mode {
    case create
    case find
    case search
    case none
}