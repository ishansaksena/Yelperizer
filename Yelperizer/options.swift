//
//  options.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/7/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

import Foundation

struct option {
    var icon: String?
    var actions: String?
}

var options = [option]()

func setDefaultOptions() {
    options.append(option(icon: "➕", actions: "Create new"))
    options.append(option(icon: "😌", actions: "Join"))
    options.append(option(icon: "🐼|🐭", actions: "Not you?"))
    options.append(option(icon: "🚀", actions: "Logout"))
    options.append(option(icon: "🔍", actions: "Search"))
}