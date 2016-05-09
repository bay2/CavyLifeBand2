//
//  HelpAndFeedbackVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class HelpAndFeedbackVC: UIViewController, BaseViewControllerPresenter {
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    var navTitle: String { return L10n.RelateHelpAndFeedbackNavTitle.string }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        baseUISetting()
        
        updateNavUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func baseUISetting() {
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        textView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        textView.font = UIFont.systemFontOfSize(14.0)
        
        textView.textColor = UIColor(named: .TextFieldTextColor)
        
        textView.placeholderColor = UIColor(named: .RalateHelpFeedbackTextViewPlaceHolderColor)
        
        textView.placeholder = L10n.RelateHelpAndFeedbackTextViewPlaceHolder.string
        
        sendBtn.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        sendBtn.setTitle(L10n.RelateHelpAndFeedbackSendBtnTitle.string, forState: .Normal)
        
        sendBtn.backgroundColor = UIColor(named: .RalateHelpFeedbackSendBtnBGColor)
        
        sendBtn.setTitleColor(UIColor(named: .RalateHelpFeedbackSendBtnTitleColor), forState: .Normal)
    }
  
    @IBAction func sendAction(sender: UIButton) {
        Log.info("发送帮助与反馈")
    }

}
