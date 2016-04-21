//
//  PKInfoOrResultView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKInfoOrResultView: UIView {

    @IBOutlet weak var topBGView: UIView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var competitorAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var competitorNameLabel: UILabel!
    @IBOutlet weak var userStepLabel: UILabel!
    @IBOutlet weak var competitorStepLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var seeStateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let smallAvatarWidth: CGFloat = 80.0
    let bigAvatarWidth: CGFloat = 110.0
    
    var winnerImageView: UIImageView = {
        
        return UIImageView.init(image: UIImage(named: "PKWinner"))
        
    }()
    
    var dataSource: PKInfoOrResultViewDataSource?
    
    override func awakeFromNib() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        self.bringSubviewToFront(userAvatarImageView)
        self.bringSubviewToFront(competitorAvatarImageView)
        
        self.addSubview(winnerImageView)
        
        winnerImageView.hidden = true
        
        dataSource = PKInfoOrResultViewModel()
        
        dataSourceSetting()
        
        baseSetting()
        
        
    }
    
    func baseSetting() -> Void {
        
        seeStateLabel.font = dataSource?.matrixFont
        
        seeStateLabel.textColor = UIColor(named: .PKInfoOrResultViewNormalTextColor)
        
        timeTitleLabel.textColor = UIColor(named: .PKInfoOrResultViewNormalTextColor)
        
        userAvatarImageView.layer.borderColor       = UIColor.whiteColor().CGColor
        competitorAvatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        userAvatarImageView.layer.borderWidth       = 3.0
        competitorAvatarImageView.layer.borderWidth = 3.0
        
        userAvatarImageView.clipsToBounds = true
        competitorAvatarImageView.clipsToBounds = true
        
        winnerImageView.snp_makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
    }
    
    func winnerBoth() -> Void {
        competitorAvatarImageView.snp_makeConstraints { (make) in
            
            make.leading.equalTo(topBGView.snp_centerX).offset(30)
            
            make.width.equalTo(smallAvatarWidth)
        }
        
        userAvatarImageView.snp_makeConstraints { (make) in
            
            make.trailing.equalTo(topBGView.snp_centerX).offset(-30)
            
            make.width.equalTo(smallAvatarWidth)
        }
        userAvatarImageView.layer.cornerRadius = smallAvatarWidth / 2
        competitorAvatarImageView.layer.cornerRadius = smallAvatarWidth / 2
    }
    
    func winnerCompetitorSetting() -> Void {
        
        if dataSource?.isPKEnd == true {
            competitorNameLabel.text = (dataSource?.competitorName)! + L10n.PKCustomViewWinState.string
            
            winnerImageView.hidden = false
            
            winnerImageView.snp_makeConstraints { (make) in
                make.trailing.equalTo(competitorAvatarImageView.snp_trailing)
                make.top.equalTo(competitorAvatarImageView.snp_top).offset(-6)
            }
        }
        
        competitorAvatarImageView.snp_makeConstraints { (make) in
            
            make.leading.equalTo(topBGView.snp_centerX)
            
            make.width.equalTo(bigAvatarWidth)
        }
        
        userAvatarImageView.snp_makeConstraints { (make) in
            
            make.trailing.equalTo(topBGView.snp_centerX).offset(-30)
            
            make.width.equalTo(smallAvatarWidth)
        }
        
        competitorNameLabel.font = UIFont.systemFontOfSize(18)
        competitorStepLabel.font = UIFont.boldSystemFontOfSize(32)
        
        competitorStepLabel.textColor = UIColor(named: .PKInfoOrResultViewWinnerTextColor)
        competitorNameLabel.textColor = UIColor(named: .PKInfoOrResultViewWinnerTextColor)
        
        competitorAvatarImageView.layer.cornerRadius = bigAvatarWidth / 2
        userAvatarImageView.layer.cornerRadius = smallAvatarWidth / 2
    }
    
    
    func winnerUserSetting() -> Void {
            
        if dataSource?.isPKEnd == true {
            userNameLabel.text = (dataSource?.userName)! + L10n.PKCustomViewWinState.string
            
            winnerImageView.hidden = false
            
            winnerImageView.snp_makeConstraints { (make) in
                make.trailing.equalTo(userAvatarImageView.snp_trailing)
                make.top.equalTo(userAvatarImageView.snp_top).offset(-6)
            }
        }
        
        competitorNameLabel.text = dataSource?.competitorName
        
        competitorAvatarImageView.snp_makeConstraints { (make) in
            
            make.leading.equalTo(topBGView.snp_centerX).offset(30)
            
            make.width.equalTo(smallAvatarWidth)
        }
        
        userAvatarImageView.snp_makeConstraints { (make) in
            
            make.trailing.equalTo(topBGView.snp_centerX)
            
            make.width.equalTo(bigAvatarWidth)
        }
        
        userNameLabel.font = UIFont.systemFontOfSize(18)
        userStepLabel.font = UIFont.boldSystemFontOfSize(32)
        
        userNameLabel.textColor = UIColor(named: .PKInfoOrResultViewWinnerTextColor)
        userStepLabel.textColor = UIColor(named: .PKInfoOrResultViewWinnerTextColor)
        
        userAvatarImageView.layer.cornerRadius = bigAvatarWidth / 2
        competitorAvatarImageView.layer.cornerRadius = smallAvatarWidth / 2
    }
    
    func dataSourceSetting() -> Void {
        
        userStepLabel.text       = dataSource?.userStepCount.toString
        competitorStepLabel.text = dataSource?.competitorStepCount.toString

        userNameLabel.text       = dataSource?.userName
        competitorNameLabel.text = dataSource?.competitorName
        
        timeTitleLabel.text = dataSource?.timeTitle
        seeStateLabel.text  = dataSource?.seeStateTitle
        
        timeLabel.attributedText = dataSource?.timeFormatterStr()
        
        
        if dataSource?.winner == .User {
            winnerUserSetting()
        } else if dataSource?.winner == .Competitor {
            winnerCompetitorSetting()
        } else {
            winnerBoth()
        }

    }

}

enum Winner {
    
    case User
    
    case Competitor
    
    case Both
}

protocol PKInfoOrResultViewDataSource {
    var isPKEnd: Bool { get }
    
    var isOtherCanSee: Bool { get }
    
    var userStepCount: Int { get }
    
    var competitorStepCount: Int { get }
    
    var userName: String { get }
    
    var competitorName: String { get }
    
    var timeTitle: String { get }
    
    var seeStateTitle: String { get }
    
    var winner: Winner { get }
    
    var matrixFont: UIFont { get }
    
//    var userAvatar: UIImage { get }
//    var comprtitorAvatar: UIImage { get }
    
    func timeFormatterStr() -> NSMutableAttributedString
    
}

extension PKInfoOrResultViewDataSource {
    
    var userName: String { return L10n.PKCustomViewUserName.string }
    
    var matrixFont: UIFont {
        
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(5 * Float(M_PI) / 180)), 1, 0, 0)
        let desc   = UIFontDescriptor(name: UIFont.systemFontOfSize(14).fontName, matrix: matrix)
        let font   = UIFont(descriptor: desc, size: 14)
        
        return font
    }

}

struct PKInfoOrResultViewModel: PKInfoOrResultViewDataSource {
    var isPKEnd: Bool = true
    
    var userStepCount: Int = 123
    
    var competitorStepCount: Int = 1234
    
    var competitorName: String = "雪菜炒饭"
    
    var isOtherCanSee: Bool = true
    
    var timeTitle: String {
        if isPKEnd == true {
            return L10n.PKInfoOrResultViewPKEndTimeTitle.string
        } else {
            return L10n.PKInfoOrResultViewPKNotEndTimeTitle.string
        }
    }
    
    var seeStateTitle: String {
        if isOtherCanSee == true {
            return L10n.PKInvitationVCPKOtherSeeAble.string
        } else {
            return L10n.PKInvitationVCPKOtherSeeUnable.string
        }
    }
    
    var winner: Winner {
        if userStepCount > competitorStepCount {
            return .User
        } else if userStepCount < competitorStepCount {
            return .Competitor
        } else {
            return .Both
        }
    }
    
    /**
     时间格式转换
     */
    func timeFormatterStr() -> NSMutableAttributedString {
        
        if isPKEnd == true {
            return addAttributeText("1")
        } else {
            return addAttributeText("1", hour: "2", minutes: "22")
        }

    }
    
    /**
     富文本
     */
    func addAttributeText(day: String, hour: String = "", minutes: String = "",
                          dayUnit: String = L10n.PKInfoOrResultViewDayUnit.string,
                          hourUnit: String = L10n.PKInfoOrResultViewHourUnit.string,
                          minUnit: String = L10n.PKInfoOrResultViewMinUnit.string) -> NSMutableAttributedString {
        
        var string = day + dayUnit
        
        if isPKEnd != true {
            string = string + hour + hourUnit + minutes + minUnit
        }
        
        let currentString = NSMutableAttributedString(string: string)
        
        currentString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(24), range: NSMakeRange(0, day.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12), range: NSMakeRange(day.length, dayUnit.length))
        
        if isPKEnd == true {
            return currentString
        }
        
        currentString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(24), range: NSMakeRange(day.length + dayUnit.length, hour.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12), range: NSMakeRange(day.length + dayUnit.length + hour.length, hourUnit.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(24), range: NSMakeRange(day.length + dayUnit.length + hour.length + hourUnit.length, minutes.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12), range: NSMakeRange(day.length + dayUnit.length + hour.length + hourUnit.length + minutes.length, minUnit.length))
        
        return currentString
    }
    
}


