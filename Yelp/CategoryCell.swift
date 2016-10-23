//
//  CategoryCell.swift
//  Yelp
//
//  Created by Duy Huynh Thanh on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CategoryCellDelegate {
    @objc optional func categoryCell(categoryCell: CategoryCell, didChangeValue value: Bool)
}

class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    weak var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwichChanged(_ sender: UISwitch) {
        print("Switch changed to \(sender.isOn)")
        
        delegate?.categoryCell!(categoryCell: self, didChangeValue: sender.isOn)
    }
}
