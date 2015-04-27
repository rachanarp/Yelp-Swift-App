//
//  BusinessCellTableViewCell.swift
//  Yelp
//
//  Created by Rachana Bedekar on 4/25/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessCellTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var business : Business = Business()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.thumbImageView.layer.cornerRadius = 3
        self.thumbImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBusinessModel (business : Business) {
        self.business = business
        self.nameLabel.text = self.business.name
        self.thumbImageView.setImageWithURL(NSURL(string:self.business.imageUrl))
        self.ratingLabel.text = String (format: "%d reviews", self.business.numReviews)
        self.ratingImageView.setImageWithURL(NSURL(string:self.business.ratingImageUrl))
        self.addressLabel.text = self.business.address
        self.distanceLabel.text = String (format: "%.2f mi", self.business.distance)
        self.categoryLabel.text = self.business.categories
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
       // self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        
    }
}
