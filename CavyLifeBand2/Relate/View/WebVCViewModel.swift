//
//  WebVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

struct HelpAndFeedBackWebViewModel: WebVCDataSourceProtocol {
    var navTitle: String = L10n.RelateHelpAndFeedbackNavTitle.string
    
    var navRightBtnTitle: String = L10n.RelateHelpAndFeedbackNavRightBtnTitle.string
    
    var webUrlStr: String
    
    var navRightBtnAction: navBtnHandle
    
    init(webUrlStr: String, navAction: navBtnHandle) {
        
        self.webUrlStr = webUrlStr
        
        self.navRightBtnAction = navAction
        
    }
    
}

struct UseAndPrivateWebViewModel: WebVCDataSourceProtocol {
    
    var navTitle: String = L10n.RelateAboutUseAndPrivate.string
    
//    var navRightBtnTitle: String = ""
    
    var webUrlStr: String = "http://www.baidu.com"
    
//    var navRightBtnAction: navBtnHandle = {}
    
}

struct CopyrightWebViewModel: WebVCDataSourceProtocol {
    
    var navTitle: String = L10n.RelateAboutCopyrightNavTitle.string
    
//    var navRightBtnTitle: String = ""
    
    var webUrlStr: String = "http://www.baidu.com"
    
//    var navRightBtnAction: navBtnHandle = {}
    
}

struct OfficialWebViewModel: WebVCDataSourceProtocol {
    
    var navTitle: String = L10n.RelateAboutOfficialWebsiteNavTitle.string
    
//    var navRightBtnTitle: String = ""
    
    var webUrlStr: String = "http://www.baidu.com"
    
//    var navRightBtnAction: navBtnHandle = {}
    
}
