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
    @IBOutlet weak var sendButton: MainPageButton!
    
    var requestStyle: RequestStyle = .AddFriend
    
    var navTitle: String {
        
        return dataSource?.navTitle ?? ""
    
    }
    
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
        
        dataSource?.textFieldTitle = requestTextField.text ?? ""
        delegate?.onClickButton()
        
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
        
        sendButton.setTitle(dataSource?.bottonTitle, forState: .Normal)
        
        requestTextField.placeholder = dataSource?.placeholderText
        requestTextField.text = dataSource?.textFieldTitle
        requestTextField.textColor = UIColor(named: .TextFieldTextColor)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
