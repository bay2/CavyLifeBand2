//
//  ContactListEmptyView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ContactListEmptyView: UIView {

    @IBOutlet weak var infoLabel: UILabel!
    
    var displayInfo: String = "" {
        didSet {
            infoLabel.text = displayInfo
        }
    }
    
    override func awakeFromNib() {
        infoLabel.textColor = UIColor(named: .HColor)
        infoLabel.font = UIFont.mediumSystemFontOfSize(14.0)
        self.backgroundColor = UIColor.whiteColor()
    }

}
