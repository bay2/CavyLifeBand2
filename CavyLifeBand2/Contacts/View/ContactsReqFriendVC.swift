//
//  VerifyViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import MHRotaryKnob
import Log

class ContactsReqFriendVC: ContactsBaseViewController {

    enum RequestStyle {
        
        case AddFriend
        case ChangeNotesName
        case ChangeSelfName
        
    }
    
    /// TextField
    @IBOutlet weak var requestTextField: UITextField!
    
    /// Button
    @IBOutlet weak var sendButton: UIButton!
    
    var requestStyle: RequestStyle = .AddFriend
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)

        requestViewLayout()
        
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        
        switch requestStyle {
            
        // 添加好友的回调
        case .AddFriend:
            Log.info("好友请求\(requestTextField.text)")
            
        // 修改备注的回调
        case .ChangeNotesName:
            Log.info("修改备注\(requestTextField.text)")
            
        // 修改自己的昵称
        case .ChangeSelfName:
            Log.info("修改昵称\(requestTextField.text)")
            
        }
    
        // 返回前页
        self.popVC()
    }
    
    
    func requestViewLayout() {
        
        sendButton.layer.cornerRadius = CavyDefine.commonCornerRadius
        sendButton.setTitleColor(UIColor(named: .MainPageBtnText), forState: .Normal)
        sendButton.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(requestTextField).offset(requestTextField.frame.height)
            
        }
        
        switch requestStyle {

            // 请求添加好友
        case .AddFriend:
                requestTextField.placeholder = "  \(L10n.ContactsRequestPlaceHolder.string)"
                sendButton.setTitle(L10n.ContactsRequestSendButton.string, forState: .Normal)
            
            // 修改备注名字
        case .ChangeNotesName:
                requestTextField.placeholder = "  \(L10n.ContactsChangeNotesNamePlaceHolder.string)"
                sendButton.setTitle(L10n.ContactsChangeNotesNameButton.string, forState: .Normal)
            
            // 修改自己的昵称
        case .ChangeSelfName:
            requestTextField.placeholder = "  \(L10n.ContactsChangeSelfNamePlaceHolder.string)"
            sendButton.setTitle(L10n.ContactsChangeNotesNameButton.string, forState: .Normal)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
