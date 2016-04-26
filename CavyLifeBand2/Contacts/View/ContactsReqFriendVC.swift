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

class ContactsReqFriendVC: UIViewController, BaseViewControllerPresenter {

    enum RequestStyle {
        
        case AddFriend
        case ChangeNotesName
        case ChangeSelfName
        
    }
    
    var delegate: ContactsReqFriendViewControllerDelegate?
    var dataSource: ContactsReqFriendViewControllerDataSource?
    
    @IBOutlet weak var textFieldView: UIView!
    
    /// TextField
    @IBOutlet weak var requestTextField: UITextField!
    
    /// Button
    @IBOutlet weak var sendButton: UIButton!
    
    var requestStyle: RequestStyle = .AddFriend
    
    var navTitle: String { return L10n.ContactsTitle.string }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()

        requestViewLayout()
        
    }
    
    /**
     点击发送按钮
     
     - parameter sender:
     */
    @IBAction func sendRequest(sender: AnyObject) {
        
        delegate?.verifyMsg = requestTextField.text ?? ""
        delegate?.onClickButton()
        
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
    
    
    /**
     配置视图
     
     - parameter dataSource:
     */
    func viewConfig(dataSource: ContactsReqFriendViewControllerDataSource, delegate: ContactsReqFriendViewControllerDelegate) {
        
        self.delegate = delegate
        self.dataSource = dataSource
        
    }
    
    
    /**
     布局
     */
    func requestViewLayout() {
        
        textFieldView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        sendButton.layer.cornerRadius = CavyDefine.commonCornerRadius
        sendButton.setTitleColor(UIColor(named: .MainPageBtnText), forState: .Normal)
        sendButton.setBackgroundColor(UIColor(named: .MainPageBtn), forState: .Normal)
        sendButton.backgroundColor = UIColor(named: .MainPageBtn)
        sendButton.setTitle(dataSource?.bottonTitle, forState: .Normal)
        
        requestTextField.placeholder = dataSource?.placeholderText
        requestTextField.text = dataSource?.textFieldTitle
        requestTextField.textColor = UIColor(named: .TextFieldTextColor)
        
        
//        switch requestStyle {
//
//            // 请求添加好友
//        case .AddFriend:
//                requestTextField.placeholder = L10n.ContactsRequestPlaceHolder.string
//                sendButton.setTitle(L10n.ContactsRequestSendButton.string, forState: .Normal)
//            
//            // 修改备注名字
//        case .ChangeNotesName:
//                requestTextField.placeholder = L10n.ContactsChangeNotesNamePlaceHolder.string
//                sendButton.setTitle(L10n.ContactsChangeNotesNameButton.string, forState: .Normal)
//            
//            // 修改自己的昵称
//        case .ChangeSelfName:
//            requestTextField.placeholder = L10n.ContactsChangeSelfNamePlaceHolder.string
//            sendButton.setTitle(L10n.ContactsChangeNotesNameButton.string, forState: .Normal)
//            
//        }
        
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
