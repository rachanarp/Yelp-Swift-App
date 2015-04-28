//
//  SwitchCell.swift
//  Yelp
//
//  Created by Rachana Bedekar on 4/26/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol SwitchCellDelegate {
    
    optional func switchCell(SwitchCell: SwitchCell, didChangeValue value:Bool)
    
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var switchLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    @IBOutlet weak var onSwitch: UISwitch!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        onSwitch.setOn(selected, animated: animated)
    }
    
    func switchValueChanged() {
    
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)
        
    }

}
