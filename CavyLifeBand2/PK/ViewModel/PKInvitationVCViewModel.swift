//
//  PKInvitationVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

struct PKInvitationVCViewModel {
    
    var competitorId: String = { return "" }()
    
    var selectTime: String?
    
    var selectIndex: Int = 1 {
        didSet {
            selectTime = timeArr[selectIndex]
        }
    }
    
    var otherCanSee: Bool = false
    
    var timeArr: [String] = {
        return ["",
                "1",
                "2",
                "3",
                "4",
                "5",
                ""]
    }()
    
}
