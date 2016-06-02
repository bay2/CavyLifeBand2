//
//  PKRulesView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKRulesView: UIView {

    @IBOutlet weak var PKView: UIView!
    
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var seeView: UIView!
    @IBOutlet weak var howPKTitleLabel: UILabel!
    @IBOutlet weak var howPKInfoLabel: UILabel!
    @IBOutlet weak var howWinTitleLabel: UILabel!
    @IBOutlet weak var howWinInfoLabel: UILabel!
    @IBOutlet weak var howSeeTitleLabel: UILabel!
    @IBOutlet weak var howSeeInfoLabel: UILabel!
    
    override func awakeFromNib() {
        
        howPKTitleLabel.text = L10n.PKRulesViewHowPKTitle.string
        howWinTitleLabel.text = L10n.PKRulesViewHowWinTitle.string
        howSeeTitleLabel.text = L10n.PKRulesViewHowSeeTitle.string
        
        howPKInfoLabel.text = L10n.PKRulesViewHowPKInfo.string
        howWinInfoLabel.text = L10n.PKRulesViewHowWinInfo.string
        howSeeInfoLabel.text = L10n.PKRulesViewHowSeeInfo.string
        
        howPKTitleLabel.textColor = UIColor(named: .AColor)
        howWinTitleLabel.textColor = UIColor(named: .AColor)
        howSeeTitleLabel.textColor = UIColor(named: .AColor)
        
        howPKInfoLabel.textColor = UIColor(named: .AColor)
        howWinInfoLabel.textColor = UIColor(named: .AColor)
        howSeeInfoLabel.textColor = UIColor(named: .AColor)
        
        howPKTitleLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        howWinTitleLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        howSeeTitleLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        
        howPKInfoLabel.font = UIFont.systemFontOfSize(12.0)
        howWinInfoLabel.font = UIFont.systemFontOfSize(12.0)
        howSeeInfoLabel.font = UIFont.systemFontOfSize(12.0)
        
    }
    
    func configure(dataSource: PKRulesViewDataSource) {
        howPKTitleLabel.textColor = dataSource.titleColor
        howWinTitleLabel.textColor = dataSource.titleColor
        howSeeTitleLabel.textColor = dataSource.titleColor
        
        howPKInfoLabel.textColor = dataSource.infoColor
        howWinInfoLabel.textColor = dataSource.infoColor
        howSeeInfoLabel.textColor = dataSource.infoColor
    }
    
}

protocol PKRulesViewDataSource {
    
    var titleColor: UIColor { get }
    var infoColor: UIColor { get }
    
}

struct PKIntroduceVCViewDataSource: PKRulesViewDataSource {
    var titleColor: UIColor = UIColor(named: .AColor)
    var infoColor: UIColor = UIColor(named: .AColor)
}

struct PKRulesVCViewDataSource: PKRulesViewDataSource {
    var titleColor: UIColor = UIColor(named: .EColor)
    var infoColor: UIColor = UIColor(named: .FColor)
}
