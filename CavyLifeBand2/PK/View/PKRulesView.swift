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
        
        howPKTitleLabel.textColor = UIColor(named: .PKRulesViewTitleColor)
        howWinTitleLabel.textColor = UIColor(named: .PKRulesViewTitleColor)
        howSeeTitleLabel.textColor = UIColor(named: .PKRulesViewTitleColor)
        
        howPKInfoLabel.textColor = UIColor(named: .PKRulesViewInfoColor)
        howWinInfoLabel.textColor = UIColor(named: .PKRulesViewInfoColor)
        howSeeInfoLabel.textColor = UIColor(named: .PKRulesViewInfoColor)
        
    }
    
}
