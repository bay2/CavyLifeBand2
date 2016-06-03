//
//  PKListSectionView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKListSectionView: UIView {
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.systemFontOfSize(12)
        title.textColor = UIColor(named: .GColor)
        self.backgroundColor =  UIColor(named: .ContactsSectionColor)
        
    }


}
