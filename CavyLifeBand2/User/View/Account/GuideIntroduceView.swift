//
//  GuideIntroduceView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class GuideIntroduceView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomBGView: UIView!
    @IBOutlet weak var topBGView: UIView!
    
    override func awakeFromNib() {
        bottomBGView.backgroundColor = UIColor(named: .HomeViewMainColor)
        topBGView.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        titleLabel.textColor = UIColor(named: .AColor)
        infoLabel.textColor = UIColor(named: .AColor)
        
        titleLabel.font = UIFont.mediumSystemFontOfSize(18.0)
        infoLabel.font = UIFont.systemFontOfSize(14.0)
    }
    
    func configure(model: GuideIntroduceViewDataSource) {
        imageView.image = model.image
        
        titleLabel.text = model.title
        
        infoLabel.text = model.info
        
    }

}


protocol GuideIntroduceViewDataSource {
    
    var title: String { get }
    
    var info: String { get }
    
    var image: UIImage { get }

}

struct GuideRemindDataSource: GuideIntroduceViewDataSource {
    var title: String = L10n.GuidePhoneRemindTitle.string
    
    var info: String = L10n.GuidePhoneRemindInfo.string
    
    var image: UIImage = UIImage(named: "banner_2")!
}

struct GuidePKDataSource: GuideIntroduceViewDataSource {
    var title: String = L10n.GuidePKTitle.string
    
    var info: String = L10n.GuidePKInfo.string
    
    var image: UIImage = UIImage(named: "banner_3")!
}

struct GuideSafetyDataSource: GuideIntroduceViewDataSource {
    var title: String = L10n.GuideSafetyServiceTitle.string
    
    var info: String = L10n.GuideSafetyServiceInfo.string
    
    var image: UIImage = UIImage(named: "banner_1")!
}

struct GuideLoginDataSource: GuideIntroduceViewDataSource {
    var title: String = ""
    
    var info: String = ""
    
    var image: UIImage = UIImage(named: "banner_home")!
}

struct GuideLifeBandDataSource: GuideIntroduceViewDataSource {
    var title: String = L10n.GuideLifeBandTitle.string
    
    var info: String = L10n.GuideLifeBandInfo.string
    
    var image: UIImage = UIImage(named: "banner_home")!
}