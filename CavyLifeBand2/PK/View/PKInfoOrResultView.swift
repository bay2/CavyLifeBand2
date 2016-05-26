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
        
        self.addSubview(winnerImageView)
        
        winnerImageView.hidden = true
        
        baseSetting()
        
    }
    
    func baseSetting() -> Void {
        
        seeStateLabel.textColor = UIColor(named: .PKInfoOrResultViewNormalTextColor)
        
        timeTitleLabel.textColor = UIColor(named: .PKInfoOrResultViewNormalTextColor)
        
        userAvatarImageView.layer.borderColor       = UIColor.whiteColor().CGColor
        competitorAvatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        userAvatarImageView.layer.borderWidth       = 3.0
        competitorAvatarImageView.layer.borderWidth = 3.0
        
        userAvatarImageView.clipsToBounds = true
        competitorAvatarImageView.clipsToBounds = true
        
        winnerImageView.snp_makeConstraints {(make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
    }
    
    //双方打平的UI设置
    func winnerBoth() -> Void {
        
        competitorAvatarImageView.snp_makeConstraints {(make) in
            
            make.leading.equalTo(topBGView.snp_centerX).offset(30)
            
            make.width.equalTo(smallAvatarWidth)
            
        }
        
        userAvatarImageView.snp_makeConstraints {(make) in
            
            make.trailing.equalTo(topBGView.snp_centerX).offset(-30)
            
            make.width.equalTo(smallAvatarWidth)
        }
        userAvatarImageView.layer.cornerRadius = smallAvatarWidth / 2
        competitorAvatarImageView.layer.cornerRadius = smallAvatarWidth / 2
    }
    
    //对手赢的UI设置
    func winnerCompetitorSetting() -> Void {
        
        if dataSource?.isPKEnd == true {
            competitorNameLabel.text = (dataSource?.competitorName)! + L10n.PKCustomViewWinState.string
            
            winnerImageView.hidden = false
            
            winnerImageView.snp_makeConstraints {(make) in
                make.trailing.equalTo(competitorAvatarImageView.snp_trailing)
                make.top.equalTo(competitorAvatarImageView.snp_top).offset(-6)
            }
        }
        
        competitorAvatarImageView.snp_makeConstraints {(make) in
            
            make.leading.equalTo(topBGView.snp_centerX)
            
            make.width.equalTo(bigAvatarWidth)
        }
        
        userAvatarImageView.snp_makeConstraints {(make) in
            
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
    
    //我赢的UI设置
    func winnerUserSetting() -> Void {
            
        if dataSource?.isPKEnd == true {
            userNameLabel.text = (dataSource?.userName)! + L10n.PKCustomViewWinState.string
            
            winnerImageView.hidden = false
            
            winnerImageView.snp_makeConstraints {(make) in
                make.trailing.equalTo(userAvatarImageView.snp_trailing)
                make.top.equalTo(userAvatarImageView.snp_top).offset(-6)
            }
        }
        
        competitorNameLabel.text = dataSource?.competitorName
        
        competitorAvatarImageView.snp_makeConstraints {(make) in
            
            make.leading.equalTo(topBGView.snp_centerX).offset(30)
            
            make.width.equalTo(smallAvatarWidth)
        }
        
        userAvatarImageView.snp_makeConstraints {(make) in
            
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
    
    //model数据设置ui
    func configure(model: PKInfoOrResultViewDataSource) -> Void {
        
        self.dataSource = model
        
        self.userStepLabel.text       = self.dataSource?.userStepCount.toString
        self.competitorStepLabel.text = self.dataSource?.competitorStepCount.toString

        userNameLabel.text       = dataSource?.userName
        competitorNameLabel.text = dataSource?.competitorName
        
        timeTitleLabel.text = dataSource?.timeTitle
        
        timeLabel.attributedText = dataSource?.timeFormatterStr()
        
        seeStateLabel.font = dataSource?.matrixFont
        
        if dataSource?.winner == .User {
            winnerUserSetting()
        } else if dataSource?.winner == .Competitor {
            winnerCompetitorSetting()
        } else {
            winnerBoth()
        }
        
        userAvatarImageView.af_setCircleImageWithURL(NSURL(string: dataSource?.userAvatarUrl ?? "")!, placeholderImage: UIImage(asset: .DefaultHead))
        competitorAvatarImageView.af_setCircleImageWithURL(NSURL(string: dataSource?.comprtitorAvatarUrl ?? "")!, placeholderImage: UIImage(asset: .DefaultHead))
        
        loadInfoFromWeb()

    }

}

extension PKInfoOrResultView: PKWebRequestProtocol {
    
    //从服务器加载数据库没有的展示数据
    func loadInfoFromWeb() {
        getPKInfo({ pkInfo in
            
            self.dataSource?.userStepCount = pkInfo.userStepCount
            self.dataSource?.competitorStepCount = pkInfo.friendStepCount
            self.dataSource?.isOtherCanSee = pkInfo.isAllowWatch == PKAllowWatchState.OtherNoWatch.rawValue ? false : true
            
            self.userStepLabel.text       = self.dataSource?.userStepCount.toString
            self.competitorStepLabel.text = self.dataSource?.competitorStepCount.toString
            self.seeStateLabel.text = self.dataSource?.seeStateTitle
            
        }, failure: { errorMsg in
            Log.error(errorMsg)
        })
        
    }

}

enum Winner {
    
    case User
    
    case Competitor
    
    case Both
}

protocol PKInfoOrResultViewDataSource {
    var isPKEnd: Bool { get }
    
    var isOtherCanSee: Bool { get set }
    
    var userStepCount: Int { get set }
    
    var competitorStepCount: Int { get set }
    
    var userName: String { get }
    
    var competitorName: String { get }
    
    var timeTitle: String { get }
    
    var seeStateTitle: String { get }
    
    var winner: Winner { get }
    
    var matrixFont: UIFont { get }
    
    var userAvatarUrl: String { get }
    
    var comprtitorAvatarUrl: String { get }
    
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
    var isPKEnd: Bool
    
    var userStepCount: Int = 0
    
    var competitorStepCount: Int = 0
    
    var competitorName: String
    
    var isOtherCanSee: Bool = false
    
    var userAvatarUrl: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginAvatar
    
    var comprtitorAvatarUrl: String
    
    var pkDuration: String
    
    var beginTime: String = ""
    
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
        
        if isPKEnd == true { //pk已结束，直接显示pk时长
            
            return addAttributeText(pkDuration)
            
        } else {
            if beginTime.characters.count > 0 {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let beginDate = dateFormatter.dateFromString(beginTime)
                let duration  = pkDuration.toDouble() ?? 0
                let endDate   = beginDate?.dateByAddingTimeInterval(duration * 24 * 60 * 60)
                let nowDate   = NSDate()
                
                if endDate?.laterDate(nowDate) == endDate {
                    
                    let difDays  = nowDate.daysInBetweenDate(endDate!).toInt
                    let difHours = nowDate.hoursInBetweenDate(endDate!).toInt % 24
                    let difMins  = nowDate.minutesInBetweenDate(endDate!).toInt % 60
                    
                    return addAttributeText("\(difDays)", hour: "\(difHours)", minutes: "\(difMins)")
                    
                }
                
            }
            
            return addAttributeText("")
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
    
    init(pkRealm: PKRecordRealmDataSource) {
        
        self.isPKEnd = pkRealm is PKDueRealmModel ? false : true
        
        self.competitorName = pkRealm.nickname
        
        self.comprtitorAvatarUrl = pkRealm.avatarUrl
        
        self.pkDuration = pkRealm.pkDuration
        
        if pkRealm is PKDueRealmModel {
            let pk = pkRealm as! PKDueRealmModel
            self.beginTime = pk.beginTime
        }
        
    }
    
}


