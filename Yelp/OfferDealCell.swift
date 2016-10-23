//
//  OfferDealCell.swift
//  Yelp
//
//  Created by Duy Huynh Thanh on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol OfferDealCellDelegate {
    @objc optional func offerDealCell(offerDealCell: OfferDealCell, didChangeValue value: Bool)
}

class OfferDealCell: UITableViewCell {
    
    @IBOutlet weak var switchButton: UISwitch!

    weak var delegate: OfferDealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        print("Switch changed to \(sender.isOn)")
        
        delegate?.offerDealCell!(offerDealCell: self, didChangeValue: sender.isOn)
    }

}
