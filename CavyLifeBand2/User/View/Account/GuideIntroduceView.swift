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
    var title: String = "来电提醒"
    
    var info: String = "来电振动提醒，不漏接一个重要来电"
    
    var image: UIImage = UIImage(named: "banner_2")!
}

struct GuidePKDataSource: GuideIntroduceViewDataSource {
    var title: String = "计步PK"
    
    var info: String = "实时查看与好友计步PK详情\n让走路成为一种乐趣"
    
    var image: UIImage = UIImage(named: "banner_3")!
}

struct GuideSafetyDataSource: GuideIntroduceViewDataSource {
    var title: String = "安全服务"
    
    var info: String = "遇到紧急情况，连按4下按钮\n立即向联系人发送求救信息"
    
    var image: UIImage = UIImage(named: "banner_1")!
}

struct GuideLoginDataSource: GuideIntroduceViewDataSource {
    var title: String = ""
    
    var info: String = ""
    
    var image: UIImage = UIImage(named: "banner_home")!
}