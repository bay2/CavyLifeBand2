//
//  PKChallengeView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import AlamofireImage

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
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    var dataSource: PKChallengeViewDataSource?
    
    override func awakeFromNib() {
        baseSetting()
    }
    
    /**
     基本样式设置
     */
    func baseSetting() -> Void {
        
        PKTimeTitleLabel.text       = L10n.PKChallengeViewPKTimeTitle.string
        PKInvitationRulesLabel.text = L10n.PKChallengeViewPKRules.string

        rulesIconImageView.image    = UIImage(named: "PKAttention")
        
        userNameLabel.textColor          = UIColor(named: .EColor)
        competitorNameLabel.textColor    = UIColor(named: .EColor)
        PKTimeTitleLabel.textColor       = UIColor(named: .EColor)
        PKSeeStateLabel.textColor        = UIColor(named: .EColor)
        PKTimeLabel.textColor            = UIColor(named: .EColor)
        PKTimeUnitLabel.textColor        = UIColor(named: .EColor)
        PKInvitationRulesLabel.textColor = UIColor(named: .JColor)
        
        topLine.backgroundColor = UIColor(named: .LColor)
        bottomLine.backgroundColor = UIColor(named: .LColor)
        
        userNameLabel.font          = UIFont.mediumSystemFontOfSize(14.0)
        competitorNameLabel.font    = UIFont.mediumSystemFontOfSize(14.0)
        PKTimeTitleLabel.font       = UIFont.mediumSystemFontOfSize(14.0)
        PKSeeStateLabel.font        = UIFont.mediumSystemFontOfSize(14.0)
        PKTimeLabel.font            = UIFont.mediumSystemFontOfSize(30.0)
        PKTimeUnitLabel.font        = UIFont.mediumSystemFontOfSize(12.0)
        PKInvitationRulesLabel.font = UIFont.mediumSystemFontOfSize(12.0)
        
        userAvatarImageView.roundSquareImage()
        competitorAvatarImageView.roundSquareImage()
        
        userAvatarImageView.layer.borderColor       = UIColor.whiteColor().CGColor
        competitorAvatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        userAvatarImageView.layer.borderWidth       = 2.0
        competitorAvatarImageView.layer.borderWidth = 2.0
        
        self.clipsToBounds = true
        self.layer.cornerRadius = CavyDefine.commonCornerRadius
        
    }
    
    /**
     基于DataSource的设置
     */
    func configure(model: PKChallengeViewDataSource) -> Void {
        
        self.dataSource = model
        
        PKSeeStateLabel.font = dataSource?.matrixFont
        
        userNameLabel.text       = dataSource?.userName
        competitorNameLabel.text = dataSource?.competitorName
        PKSeeStateLabel.text     = dataSource?.seeState
        PKTimeLabel.text         = dataSource?.PKTime
        
        userAvatarImageView.af_setCircleImageWithURL(NSURL(string: dataSource?.userAvatarUrl ?? "")!, placeholderImage: UIImage(asset: .DefaultHead_small))
        competitorAvatarImageView.af_setCircleImageWithURL(NSURL(string: dataSource?.comprtitorAvatarUrl ?? "")!, placeholderImage: UIImage(asset: .DefaultHead_small))

    }
    
}

protocol PKChallengeViewDataSource {
    var userName: String { get }
    var competitorName: String { get }
    var PKTime: String { get }
    var userAvatarUrl: String { get }
    var comprtitorAvatarUrl: String { get }
    var seeState: String { get }
    var matrixFont: UIFont { get }
}

extension PKChallengeViewDataSource {
    
    var userName: String { return L10n.PKCustomViewUserName.string }
    
    var matrixFont: UIFont {
        
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(5 * Float(M_PI) / 180)), 1, 0, 0)
        let desc   = UIFontDescriptor(name: UIFont.systemFontOfSize(14).fontName, matrix: matrix)
        let font   = UIFont(descriptor: desc, size: 14)
        
        return font
    }
    
}

struct PKChallengeViewModel: PKChallengeViewDataSource {
    var competitorName: String
    
    var PKTime: String
    
    var seeState: String {
        if isOtherCanSee {
            return L10n.PKInvitationVCPKOtherSeeAble.string
        } else {
            return L10n.PKInvitationVCPKOtherSeeUnable.string
        }
    }
    
    var isOtherCanSee: Bool
    
    var userAvatarUrl = CavyDefine.loginUserBaseInfo.loginUserInfo.loginAvatar
    
    var comprtitorAvatarUrl: String
    
    init(pkRealm: PKWaitRealmModel) {
        
        comprtitorAvatarUrl = pkRealm.avatarUrl
        
        competitorName = pkRealm.nickname
        
        PKTime = pkRealm.pkDuration
        
        isOtherCanSee = pkRealm.isAllowWatch == PKAllowWatchState.OtherNoWatch.rawValue ? false : true
        
    }
}
