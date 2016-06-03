//
//  SendSafetyCodeButton.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

/// 发送验证码按钮
class SendSafetyCodeButton: UIButton {

    var count = 60
    var time: NSTimer?

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        self.setTitle(L10n.SignUpSendSafetyCode.string, forState: .Normal)
        self.titleLabel!.font = UIFont.mediumSystemFontOfSize(14)
        self.setTitleColor(UIColor(named: .FColor), forState: .Normal)

    }


    /**
     倒计时处理
     
     - parameter timer:
     */
    func countDownProc(timer: NSTimer) {

        count -= 1

        if count == 0 {

            self.setTitle(L10n.SignUpSendSafetyCode.string, forState: .Normal)
            time!.invalidate()
            self.enabled = true
            count = 60

        } else  {

            let btnTitle = "\(count) s"
            self.setTitle(btnTitle, forState: .Normal)

        }

    }

    /**
     开始倒计时
     */
    func countDown() {

        time = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SendSafetyCodeButton.countDownProc(_:)), userInfo: nil, repeats: true)

        self.enabled = false

    }
    

}
