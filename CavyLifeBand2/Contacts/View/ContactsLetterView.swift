//
//  ContactsLetterView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsLetterView: UIView {

    @IBOutlet weak var title: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.systemFontOfSize(14)
        title.textColor = UIColor(named: .GColor)
        self.backgroundColor =  UIColor(named: .ContactsSectionColor)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        
//        title.font = UIFont.systemFontOfSize(16)
//        title.textColor = UIColor(named: .ContactsLetterColor)
//
//        UIColor(named: .ContactsSectionColor).setFill()
//        UIRectFill(rect)
//
//    }

}
