//
//  HelpAndFeedbackVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import KMPlaceholderTextView

class HelpAndFeedbackVC: UIViewController, BaseViewControllerPresenter {
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    var navTitle: String { return L10n.RelateHelpAndFeedbackNavRightBtnTitle.string }
    
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
        
        textView.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        textView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        
        sendBtn.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        sendBtn.setTitle(L10n.RelateHelpAndFeedbackSendBtnTitle.string, forState: .Normal)
        
        sendBtn.backgroundColor = UIColor(named: .OColor)
        
        sendBtn.setTitleColor(UIColor(named: .PColor), forState: .Normal)
    }
  
    @IBAction func sendAction(sender: UIButton) {
        
        if textView.text.characters.count == 0 {
            return
        }
        
        self.view.endEditing(true)
                
        HelpFeedbackWebApi.shareApi.submitFeedback(textView.text, successBack: { [unowned self] in
            
            Log.info($0.msg)
            
            self.createTimer(CavyLifeBandAlertView.sharedIntance.showViewTitleWithoutAction(message: L10n.RelateHelpAndFeedbackSendSuccessAlertMsg.string), result: "1")
            
        }) { [unowned self] in
            self.createTimer(CavyLifeBandAlertView.sharedIntance.showViewTitleWithoutAction(message: $0.msg), result: "0")
        }

    }
    
    /**
     隐藏alert
     时间器的灰调
     
     - parameter sender: 
     */
    func dismissAlert(sender: NSTimer) {
        
        guard let alert: UIAlertController = sender.userInfo?["alert"] as? UIAlertController else {
            return
        }
        
        let result = sender.userInfo?["result"] as? String
        
        alert.dismissViewControllerAnimated(true) {
            
            guard result == "1" else {
                return
            }
            
            self.popVC()
            
        }
        
    }
    
    /**
     建立时间器 自动隐藏alert
     
     - parameter alert:
     - parameter result:
     */
    func createTimer(alert: UIAlertController, result: String) {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(HelpAndFeedbackVC.dismissAlert(_:)), userInfo: ["alert": alert, "result": result], repeats: false)
    }
    
  
}
