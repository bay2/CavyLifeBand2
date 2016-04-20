//
//  PKChallengeView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKChallengeView: UIView {


    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var competitorAvatarImageView: UIImageView!
    @IBOutlet weak var rulesIconImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var competitorNameLabel: UILabel!
    @IBOutlet weak var PKTimeTitleLabel: UILabel!
    @IBOutlet weak var PKTimeLabel: UILabel!
    @IBOutlet weak var PKTimeUnitLabel: UILabel!
    @IBOutlet weak var PKSeeStateLabel: UILabel!
    @IBOutlet weak var PKInvitationRulesLabel: UILabel!
    
    var dataSource: PKChallengeViewDataSource?
    
    override func awakeFromNib() {
        baseSetting()
        
//        dataSourceSetting()
    }
    
    /**
     基本样式设置
     */
    func baseSetting() -> Void {
        
        // 斜体字体
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(5 * Float(M_PI) / 180)), 1, 0, 0)
        let desc   = UIFontDescriptor(name: UIFont.systemFontOfSize(16).fontName, matrix: matrix)
        let font   = UIFont(descriptor: desc, size: 12)
        
        PKSeeStateLabel.font = font
        
        PKTimeTitleLabel.text       = L10n.PKChallengeViewPKTimeTitle.string
        PKInvitationRulesLabel.text = L10n.PKChallengeViewPKRules.string

        rulesIconImageView.image    = UIImage(named: "PKAttention")
        
        userNameLabel.textColor          = UIColor(named: .PKChallengeViewNormalTitleColor)
        competitorNameLabel.textColor    = UIColor(named: .PKChallengeViewNormalTitleColor)
        PKTimeTitleLabel.textColor       = UIColor(named: .PKChallengeViewNormalTitleColor)
        PKSeeStateLabel.textColor        = UIColor(named: .PKChallengeViewNormalTitleColor)
        PKTimeLabel.textColor            = UIColor(named: .PKChallengeViewNormalTitleColor)
        PKTimeUnitLabel.textColor        = UIColor(named: .PKChallengeViewNormalTitleColor)
        PKInvitationRulesLabel.textColor = UIColor(named: .PKChallengeViewRulesTitleColor)
        
        userAvatarImageView.roundSquareImage()
        competitorAvatarImageView.roundSquareImage()
        
        userAvatarImageView.layer.borderColor       = UIColor.whiteColor().CGColor
        competitorAvatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        userAvatarImageView.layer.borderWidth       = 3.0
        competitorAvatarImageView.layer.borderWidth = 3.0
        
        self.clipsToBounds = true
        self.layer.cornerRadius = CavyDefine.commonCornerRadius
        
    }
    
    /**
     基于DataSource的设置
     */
    func dataSourceSetting() -> Void {
        
        userAvatarImageView.image       = dataSource?.userAvatar
        competitorAvatarImageView.image = dataSource?.comprtitorAvatar
        
        userNameLabel.text       = dataSource?.userName
        competitorNameLabel.text = dataSource?.competitorName
        
        guard let otherCanSee = dataSource?.isOtherCanSee else {
            return
        }
        
        PKSeeStateLabel.text = otherCanSee ? L10n.PKInvitationVCPKOtherSeeAble.string : L10n.PKInvitationVCPKOtherSeeUnable.string

    }
    
}

protocol PKChallengeViewDataSource {
    var userName: String { get }
    var competitorName: String { get }
    var PKTime: String { get }
    var userAvatar: UIImage { get }
    var comprtitorAvatar: UIImage { get }
    var isOtherCanSee: Bool { get }
    
    
}
