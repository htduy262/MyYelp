//
//  BusinessCell.swift
//  Yelp
//
//  Created by Duy Huynh Thanh on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var starRateImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var businessData: Business! {
        didSet {
            
            avatarImageView.alpha = 0
            if let url = businessData.imageURL {
                avatarImageView.setImageWith(url)
                
                UIView.animate(withDuration: 0.6) {
                    self.avatarImageView.alpha = 1
                }
            }
            
            nameLabel.text = businessData.name
            distanceLabel.text = businessData.distance
            
            starRateImageView.alpha = 0
            if let url = businessData.ratingImageURL {
                starRateImageView.setImageWith(url)
                
                UIView.animate(withDuration: 0.6) {
                    self.starRateImageView.alpha = 1
                }
            }
            
            if let reviewCount = businessData.reviewCount {
                reviewCountLabel.text = "\(reviewCount) Reviews"
            }
            
            addressLabel.text = businessData.address
            categoryLabel.text = businessData.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
