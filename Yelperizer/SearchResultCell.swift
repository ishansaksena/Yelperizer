//
//  SearchResultCell.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/6/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchResultCell: UITableViewCell {

    //Mark: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var votes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setFor(business: JSON) {
        self.name.text = business["name"].stringValue
        self.rating.text = business["rating"].stringValue
        self.price.text = business["price"].stringValue
        self.address.text = business["location"]["address1"].stringValue
    }
}
