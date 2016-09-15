//
//  SearchParameters.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/6/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Search {
    var searchTerm: String?
    var location: String?
    var limit: Int?
    var results: JSON?
    var resultsReceived: Int?
}

var search = Search()