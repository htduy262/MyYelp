//
//  DistanceCell.swift
//  Yelp
//
//  Created by Duy Huynh Thanh on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DistanceCellDelegate {
    @objc optional func distanceCell(distanceCell: DistanceCell)
}

class DistanceCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upDownImageView: UIImageView!

    var delegate:DistanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        delegate?.distanceCell!(distanceCell: self)
    }

}
