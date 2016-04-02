//
//  ContactsSearchBar.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsSearchBar: UISearchBar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImage(UIImage.imageWithColor(UIColor(named: .ContactsSearchBarColor), size: CGSizeMake(ez.screenWidth, 44)), forBarPosition: .Any, barMetrics: .Default)
        self.placeholder = L10n.ContactsSearchBarSearch.string
        self.tintColor = UIColor.whiteColor()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
