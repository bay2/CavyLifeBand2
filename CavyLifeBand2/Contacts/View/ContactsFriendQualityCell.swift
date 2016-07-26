//
//  ContactsFriendQualityCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsFriendQualityCell: UITableViewCell {

    /// 图片
    @IBOutlet weak var imgView: UIImageView!
    
    /// 左边Label
    @IBOutlet weak var titleLable: UILabel!
    
    /// 右边数值Label
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        imgView.roundSquareImage()
        titleLable.textColor = UIColor(named: .ContactsTitleColor)
        infoLabel.textColor = UIColor(named: .ContactsName)
        separatorLine.backgroundColor = UIColor(named: .LColor)
        self.selectionStyle = .None
        
    }
    
    /**
     添加数据
     */
    func addData(image: UIImage, info: String, number: String) {
        
        imgView.image = image
        titleLable.text = info
        infoLabel.text = number
        
    }
    
    func configure(model: ContactsFriendQualityCellDataSource) {
        imgView.image = model.iconImage
        titleLable.text = model.title
        infoLabel.text = model.info
        infoLabel.textColor = model.infoTextColor
        
        separatorLine.hidden = model.hideSeparator
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

protocol ContactsFriendQualityCellDataSource {

    var title: String { get }
    
    var info: String { get }
    
    var infoValue: String { get set }
    
    var infoTextColor: UIColor { get }
    
    var iconImage: UIImage? { get }
    
    var hideSeparator: Bool { get }

}

struct PKQualityCellVM: ContactsFriendQualityCellDataSource {
    
    var title: String = L10n.ContactsShowInfoPK.string
    
    var infoTextColor: UIColor = UIColor(named: .GColor)
    
    var iconImage: UIImage? = UIImage(named: "HomeListPK")
    
    var info: String { return infoValue  }
    
    var infoValue: String = L10n.ContactsShowInfoPKSubInfo.string
    
    var hideSeparator: Bool = true
}

struct StepQualityCellVM: ContactsFriendQualityCellDataSource {
    
    var title: String = L10n.ContactsShowInfoStep.string
    
    var infoTextColor: UIColor = UIColor(named: .EColor)
    
    var iconImage: UIImage? = UIImage(named: "HomeListStep")
    
    var info: String {
        
        return self.infoValue + "步"
        
    }
    
    var infoValue: String
    
    init(infoValue: String = "") {
        
        self.infoValue = infoValue
        
    }
    
    var hideSeparator: Bool = false
    
}

struct SleepQualityCellVM: ContactsFriendQualityCellDataSource {
    
    var title: String = L10n.ContactsShowInfoSleep.string
    
    var infoTextColor: UIColor = UIColor(named: .EColor)
    
    var iconImage: UIImage? = UIImage(named: "HomeListSleep")
    
    var info: String { return infoValue }
    
    var infoValue: String
    
    init(infoValue: String = "") {
        
        self.infoValue = infoValue
        
    }
    
    var hideSeparator: Bool = false
    
}
