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
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var ratingImage1: UIImageView!
    @IBOutlet weak var ratingImage2: UIImageView!
    @IBOutlet weak var ratingImage3: UIImageView!
    @IBOutlet weak var ratingImage4: UIImageView!
    @IBOutlet weak var ratingImage5: UIImageView!
    var rating: String?

    
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
        self.rating = business["rating"].stringValue
        self.price.text = business["price"].stringValue
        self.address.text = business["location"]["address1"].stringValue
        
        // Set vote in cell
        let vote = search.votesReceived[business["id"].stringValue]
        if vote == 0 {
            self.votes.text = "Swipe"
        } else {
            self.votes.text = String(vote!)
        }
        
        // Set thumbnail images
        let squareSize = 86.0
        let size = CGSize(width: squareSize, height: squareSize)
        
        // Round and scale down the images
        // If image has loaded
        if let image = search.imageURLs[business["id"].stringValue] {
            let roundedImage = image.af_imageRoundedIntoCircle()
            let aspectScaledToFit = roundedImage.af_imageAspectScaledToFitSize(size)
            self.thumbnail?.image = aspectScaledToFit
        }
        
        // Setting rating images
        // Expected format: 1 or 4.5
        // Image name format: 4 or 4-5
        let namePrefix = "20x20_"
        
        let ratingFloat = Float(rating!)
        
        var splitRating = rating?.componentsSeparatedByString(".")
        let previousRating = splitRating![0]
        
        var imageRatingSuffix: String?
        // If rating is single digit
        if splitRating!.count == 1 {
            splitRating = [splitRating![0], ".", "0"]
        }
        // eg. 4.0
        if splitRating?.last == "0" {
            imageRatingSuffix = splitRating![0]
        } else {//eg. 4.5
            imageRatingSuffix = splitRating![0] + "-" + splitRating!.last!
        }
        
        // Making array with correct image stars in order
        var images = [UIImage?]()
        
        // Set starts before the last start which may be half
        for _ in 0...(Int(ratingFloat!) - 1) {
            images+=[UIImage(named: namePrefix + previousRating)]
        }
        
        // Set the star that may be a half
        if splitRating!.last == "5" {
            images += [UIImage(named: namePrefix + imageRatingSuffix!)]
        }
        
        // Append remainder of the images with zero rating stars
        for _ in images.count...5 {
            images += [UIImage(named: namePrefix + "0")]
        }
        
        // Update in cell
        ratingImage1.image = images[0]
        ratingImage2.image = images[1]
        ratingImage3.image = images[2]
        ratingImage4.image = images[3]
        ratingImage5.image = images[4]
    }
}
